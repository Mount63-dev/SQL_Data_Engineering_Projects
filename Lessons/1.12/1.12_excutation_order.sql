/*
find the top ten companies for posting jobs
 that must have > 3000 postings 
 only on the US market 
*/
SELECT
cd.name AS company_name,
COUNT(jpf.job_id) AS postings_count
FROM 
job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name
HAVING COUNT(jpf.job_id) > 3000
ORDER BY postings_count DESC;