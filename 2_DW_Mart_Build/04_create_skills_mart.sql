-- Step 4: Mart - Create skills demand mart (dimensional mart)
-- Run this after Step 3
-- This mart focuses on skills demand over time with clean additive measures


-- Drop existing mart schema if it exists (for idempotency)
DROP SCHEMA IF EXISTS skills_mart CASCADE;


-- Step 1: Create the mart schema
CREATE SCHEMA skills_mart;

-- Step 2: Create dimension tables
SELECT '=== Loading skills_dim For skills Mart ===' AS info;

-- Skills Dimension Table 
CREATE TABLE skills_mart.dim_skills (
    skill_id    INT PRIMARY KEY,
    skills      VARCHAR,
    type        VARCHAR
);

INSERT INTO skills_mart.dim_skills(skill_id, skills, type)
SELECT 
    skill_id,
    skills,
    type
FROM skills_dim;


-- 2. Month-level date dimension (enhanced with quarter and other attributes)
SELECT '=== Loading dim_date_month For skills Mart ===' AS info;

CREATE TABLE skills_mart.dim_date_month(
    month_start_date        DATE PRIMARY KEY,
    year                    INT,
    month                   INT,
    quarter                 INT,
    quarter_name            VARCHAR,
    year_quarter            VARCHAR
);

INSERT INTO skills_mart.dim_date_month(month_start_date, year, month, quarter, quarter_name, year_quarter)
SELECT DISTINCT
    DATE_TRUNC('month', job_posted_date)::DATE AS month_start_date,
    EXTRACT (YEAR FROM job_posted_date) AS year,
    EXTRACT (MONTH FROM job_posted_date) AS month,
    EXTRACT (QUARTER FROM job_posted_date) AS quarter,
    'Q-' || EXTRACT (QUARTER FROM job_posted_date)::VARCHAR AS quarter_name,
    EXTRACT(YEAR FROM job_posted_date)::VARCHAR || '-Q' || 
    EXTRACT(QUARTER FROM job_posted_date)::VARCHAR AS year_quarter
FROM job_postings_fact
WHERE job_posted_date IS NOT NULL;


-- Step 3: Create fact table - fact_skill_demand_monthly
SELECT '=== Loading fact_skill_demand_monthly For skills Mart ===' AS info;
-- Grain: skill_id + month_start_date + job_title_short
-- All measures are additive (counts and sums) - safe to re-aggregate
CREATE TABLE skills_mart.fact_skill_demand_monthly(
    skill_id                            INT,
    month_start_date                    DATE,
    job_title_short                     VARCHAR,
    postings_count                      INT,
    remote_postings_count               INT,
    health_insurance_postings_count     INT,
    no_degree_postings_count            INT,
    PRIMARY KEY(skill_id, month_start_date, job_title_short),
    FOREIGN KEY(skill_id) REFERENCES skills_mart.dim_skills(skill_id),
    FOREIGN KEY(month_start_date) REFERENCES skills_mart.dim_date_month(month_start_date)
);

INSERT INTO skills_mart.fact_skill_demand_monthly(
    skill_id,
    month_start_date,
    job_title_short,
    postings_count,
    remote_postings_count,
    health_insurance_postings_count,
    no_degree_postings_count
)

WITH job_postings_prepared AS (
    SELECT
    sjd.skill_id,
    DATE_TRUNC('month', jpf.job_posted_date)::DATE AS month_start_date,
    jpf.job_title_short,
    CASE WHEN jpf.job_work_from_home IS TRUE THEN 1 ELSE 0 END AS is_remote,
    CASE WHEN jpf.job_health_insurance IS TRUE THEN 1 ELSE 0 END AS has_health_insurance,
    CASE WHEN jpf.job_no_degree_mention IS TRUE THEN 1 ELSE 0 END AS no_degree_mention
FROM job_postings_fact AS jpf
INNER JOIN 
    skills_job_dim AS sjd
ON 
    jpf.job_id = sjd.job_id
)
SELECT 
    skill_id,
    month_start_date,
    job_title_short,
    COUNT(*) AS postings_count,
    COUNT(is_remote) AS remote_postings_count,
    COUNT(has_health_insurance) AS health_insurance_postings_count,
    COUNT(no_degree_mention) AS no_degree_postings_count,
FROM job_postings_prepared 
GROUP BY 
    skill_id,
    month_start_date,
    job_title_short;



-- Data Validation
SELECT 'skills dimension' AS table_name, COUNT(*) AS record_count FROM skills_mart.dim_skills
UNION ALL
SELECT 'Date Month Dimension', COUNT(*) FROM skills_mart.dim_date_month
UNION ALL
SELECT 'Skills Demand Monthly FACT', COUNT(*) FROM skills_mart.fact_skill_demand_monthly;


SELECT '=== Dim Skill Sample ===' AS info;
SELECT * FROM skills_mart.dim_skills LIMIT 10;

SELECT '=== Dim Date month Sample ===' AS info;
SELECT * FROM skills_mart.dim_date_month LIMIT 10;

SELECT '=== Fact Skill Demand Monthly Sample ===' AS info;
SELECT * FROM skills_mart.fact_skill_demand_monthly LIMIT 10;




































































































