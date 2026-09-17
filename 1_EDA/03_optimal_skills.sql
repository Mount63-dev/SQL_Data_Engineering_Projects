/*
Question: What are the most optimal skills for data engineers—balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Engineer positions with specified annual salaries.
- Why?
    - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately instead of letting rare, outlier skills distort the results.
    - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the most practical and valuable to learn for data engineering careers.
*/
SELECT 
sd.skills,
ROUND(MEDIAN(jpf.salary_year_avg), 1) AS median_salary,
COUNT(jpf.*) AS demand_count,
ROUND(LN(COUNT(jpf.*)),2) AS in_demand_count,
ROUND((LN(MEDIAN(jpf.salary_year_avg)) * LN(COUNT(jpf.*))), 0) AS optimal_score
FROM 
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = true
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING 
    count(jpf.*) >= 100
ORDER BY 
    optimal_score DESC
LIMIT 10;

/*
=====================================================================
OPTIMAL SKILLS FOR DATA ENGINEERS (DEMAND & SALARY BALANCE)
=====================================================================
1. The Undisputed Leaders:
   - SQL (Score: 83) and Python (Score: 83) tie for the top spot, 
     driven by massive remote market demand (~1,130+ jobs) and strong 
     median salaries ($130k - $135k).

2. Cloud & Modern Data Stack:
   - AWS (Score: 79) leads the cloud infrastructure tier.
   - Spark (74), Snowflake (72), and Airflow (71) form a high-value 
     processing layer, with Airflow commanding the highest individual 
     median salary ($150k) in the top 10.

3. Methodology Takeaway:
   - The log transformation successfully surfaced a balanced blend of 
     foundational languages and specialized data stack tools without 
     letting sheer volume completely overshadow compensation.
=====================================================================
┌────────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ demand_count │ in_demand_count │ optimal_score │
│  varchar   │    double     │    int64     │     double      │    double     │
├────────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ sql        │      130000.0 │         1128 │            7.03 │          83.0 │
│ python     │      135000.0 │         1133 │            7.03 │          83.0 │
│ aws        │      137320.3 │          783 │            6.66 │          79.0 │
│ spark      │      140000.0 │          503 │            6.22 │          74.0 │
│ azure      │      128000.0 │          475 │            6.16 │          72.0 │
│ snowflake  │      135500.0 │          438 │            6.08 │          72.0 │
│ airflow    │      150000.0 │          386 │            5.96 │          71.0 │
│ java       │      135000.0 │          303 │            5.71 │          67.0 │
│ kafka      │      145000.0 │          292 │            5.68 │          67.0 │
│ databricks │      132750.0 │          266 │            5.58 │          66.0 │
└────────────┴───────────────┴──────────────┴─────────────────┴───────────────┘
*/

