SELECT 
JPF.job_id,
JPF.job_title_short,
CD.name AS company_name,
CD.company_id
FROM
job_postings_fact AS JPF
LEFT JOIN company_dim AS CD
ON JPF.company_id = CD.company_id
LIMIT 10;

SELECT 
jpf.job_id,
jpf.job_title_short,
sjd.skill_id,
sd.skills
FROM
job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
ON sjd.skill_id = sd.skill_id
;