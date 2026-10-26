-- Step 5: Mart - Create priority roles mart (snapshot mart)
-- This mart focuses on priority roles and job snapshots for targeted analysis

-- Drop existing mart schema if it exists (for idempotency)
DROP SCHEMA IF  EXISTS priority_mart CASCADE;

-- Step 1: Create the mart schema
CREATE SCHEMA priority_mart;

-- Step 2: Create priority roles dimension table
-- This table defines priority levels for different job roles
CREATE TABLE priority_mart.priority_roles(
    role_id          INT PRIMARY KEY,
    role_name        VARCHAR,
    priority_lvl    INT
);

INSERT INTO priority_mart.priority_roles (role_id, role_name, priority_lvl)
VALUES 
    (1, 'Data Engineer', 2),
    (2, 'Senior Data Engineer', 1),
    (3, 'Software Engineer', 3);




-- Step 3: Create priority jobs snapshot table
-- This table contains a snapshot of jobs with their priority levels

CREATE TABLE priority_mart.priority_jobs_snapshot (
    job_id              INT PRIMARY KEY,
    job_title_short     VARCHAR,
    company_name        VARCHAR,
    job_posted_date     TIMESTAMP,
    salary_year_avg     DOUBLE,
    priority_lvl        INT,
    updated_at          TIMESTAMP
);
INSERT INTO priority_mart.priority_jobs_snapshot(
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at 
)
SELECT 
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    pr.priority_lvl,
    CURRENT_TIMESTAMP 
FROM job_postings_fact AS jpf 
LEFT JOIN
    company_dim AS cd
ON 
    jpf.company_id = cd.company_id 
INNER JOIN 
    priority_mart.priority_roles AS pr 
ON
    jpf.job_title_short = pr.role_name;

-- Verify mart was created
SELECT 'priority Roles dimension' AS table_name, COUNT(*) AS record_count FROM priority_mart.priority_roles
UNION ALL 
SELECT 'priority jobs snapshot', COUNT(*) FROM priority_mart.priority_jobs_snapshot;


-- Show sample data from each table
SELECT '=== priority roles sample ===' AS info;
SELECT * FROM priority_mart.priority_roles ;

SELECT '=== priority jobs snapshot sample ===' AS info;
SELECT 
    job_title_short,
    COUNT(job_id) AS job_count,
    MIN(priority_lvl) AS priority_lvl,
    MIN(updated_at) AS updated_at
FROM priority_mart.priority_jobs_snapshot 
GROUP BY job_title_short
ORDER BY job_count DESC;



































































