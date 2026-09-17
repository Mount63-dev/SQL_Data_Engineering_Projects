/*
Question:
* what are the most in demand skills for data engineers?
* identify whar the top 10_demanded skills for data engineers 
* gocus on remote job postings 
* why?

  * Reteieves the top 10 skills with
    the highst demand in the  
    remote  job market, providing insights
    into the most valuable skills for 
    data engineers seeking remote work 
*/
SELECT
    sd.skills,
    count(sjd.*) AS skill_count
FROM 
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd 
    ON sjd.skill_id = sd.skill_id
WHERE
     jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = true
GROUP BY 
    sd.skills
ORDER BY 
    skill_count DESC
LIMIT 10;


/*
=====================================================================
TOP IN-DEMAND SKILLS ANALYSIS
=====================================================================
1. Core Data Foundations:
   - SQL (29,221) and Python (28,776) dominate the job market by a massive 
     margin, serving as the essential backbone for data roles.

2. Cloud Infrastructure:
   - AWS leads cloud platform demand with 17,823 mentions, followed 
     by Azure (14,143) and GCP (6,446).

3. Modern Data Stack & Big Data:
   - Enterprise data processing, warehousing, and orchestration tools 
     show very strong adoption: Spark (12,799), Airflow (9,996), 
     Snowflake (8,639), and Databricks (8,183).
=====================================================================
┌────────────┬─────────────┐
│   skills   │ skill_count │
│  varchar   │    int64    │
├────────────┼─────────────┤
│ sql        │       29221 │
│ python     │       28776 │
│ aws        │       17823 │
│ azure      │       14143 │
│ spark      │       12799 │
│ airflow    │        9996 │
│ snowflake  │        8639 │
│ databricks │        8183 │
│ java       │        7267 │
│ gcp        │        6446 │
└────────────┴─────────────┘
*/