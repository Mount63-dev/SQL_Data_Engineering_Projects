/*
Question: what are the highst paying skills for data engneers
* calculate the median salary for each skill required in data engineer postions 
* focus on remote postions with specified salaries 
* include skill frequency to identofy both salary and demand 
*why?

    -Helps identify which skills command is the highest  
    compensaition while also showing how common those skills are providing 
    a more complete picture for skill development priorities
    -The median is used instead of the average to reduce
     the impact of outlier salaries  
*/
SELECT
    sd.skills,
   ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    count(sjd.*) AS demand_count
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER join skills_dim AS sd 
    ON sjd.skill_id = sd.skill_id
WHERE
     jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = true
GROUP BY 
    sd.skills
HAVING 
    count(sd.skills) >= 100
ORDER BY 
    median_salary DESC
LIMIT 25;

/*
=====================================================================
SKILLS SALARY & DEMAND ANALYSIS INSIGHTS
=====================================================================
1. Top Earning Skills:
   - Rust leads the chart as the highest-paying skill at $210,000.
   - Terraform and Golang follow closely, tying at $184,000.
   - Enterprise and backend tools like Spring ($175.5k) and Neo4j ($170k)
     round out the top tier.

2. Key Trends & Patterns:
   - Infrastructure & Systems: Systems-level programming and cloud/DevOps 
     tools dominate the highest compensation brackets.
   - Demand vs. Pay Trade-off: Mass-market tools like Airflow (~10k demand) 
     and Kubernetes (~4.2k demand) see massive job volume, whereas specialized 
     languages like Rust command elite pay despite lower overall openings (~232).
=====================================================================

┌────────────┬───────────────┬──────────────┐
│   skills   │ median_salary │ demand_count │
│  varchar   │    double     │    int64     │
├────────────┼───────────────┼──────────────┤
│ rust       │      210000.0 │          232 │
│ terraform  │      184000.0 │         3248 │
│ golang     │      184000.0 │          912 │
│ spring     │      175500.0 │          364 │
│ neo4j      │      170000.0 │          277 │
│ gdpr       │      169616.0 │          582 │
│ zoom       │      168438.0 │          127 │
│ graphql    │      167500.0 │          445 │
│ mongo      │      162250.0 │          265 │
│ fastapi    │      157500.0 │          204 │
│ django     │      155000.0 │          265 │
│ bitbucket  │      155000.0 │          478 │
│ crystal    │      154224.0 │          129 │
│ c          │      151500.0 │          444 │
│ atlassian  │      151500.0 │          249 │
│ typescript │      151000.0 │          388 │
│ kubernetes │      150500.0 │         4202 │
│ ruby       │      150000.0 │          736 │
│ node       │      150000.0 │          179 │
│ airflow    │      150000.0 │         9996 │
│ css        │      150000.0 │          262 │
│ redis      │      149000.0 │          605 │
│ vmware     │      148798.0 │          136 │
│ ansible    │      148798.0 │          475 │
│ jupyter    │      147500.0 │          400 │
└────────────┴───────────────┴──────────────
*/