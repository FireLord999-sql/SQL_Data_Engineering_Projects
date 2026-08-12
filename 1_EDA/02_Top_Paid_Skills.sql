
select s.skills as skill,count(j.job_id) as Job_Count , median(salary_year_avg) as Median_Salary from
 job_postings_fact j 
inner join skills_job_dim sj    
on j.job_id = sj.job_id
inner join skills_dim s
on sj.skill_id =  s.skill_id
where 
job_work_from_home IS TRUE 
and job_title_short like 'Data Engineer'


group by  s.skills  
having count(j.job_id)>100

order by median(salary_year_avg) desc;


┌────────────┬───────────┬───────────────┐
│   skill    │ Job_Count │ Median_Salary │
│  varchar   │   int64   │    double     │
├────────────┼───────────┼───────────────┤
│ rust       │       232 │      210000.0 │
│ golang     │       912 │      184000.0 │
│ terraform  │      3248 │      184000.0 │
│ spring     │       364 │      175500.0 │
│ neo4j      │       277 │      170000.0 │
│ gdpr       │       582 │      169615.5 │
│ zoom       │       127 │      168437.5 │
│ graphql    │       445 │      167500.0 │
│ mongo      │       265 │      162250.0 │
│ fastapi    │       204 │      157500.0 │
│ django     │       265 │      155000.0 │
│ bitbucket  │       478 │      155000.0 │
│ crystal    │       129 │      154223.5 │
│ atlassian  │       249 │      151500.0 │
│ c          │       444 │      151500.0 │
│ typescript │       388 │      151000.0 │
│ kubernetes │      4202 │      150500.0 │
│ node       │       179 │      150000.0 │
│ ruby       │       736 │      150000.0 │
│ css        │       262 │      150000.0 │
│ airflow    │      9996 │      150000.0 │
│ redis      │       605 │      149000.0 │
│ vmware     │       136 │     148798.25 │
│ ansible    │       475 │     148798.25 │
│ jupyter    │       400 │      147500.0 │
└────────────┴───────────┴───────────────┘
  25 rows                      3 columns
 





/*

Key Insights:

1. Systems & High-Performance Languages Command Top CompensationRust leads all skills with a median salary of $210,000 (232 postings).Golang ($184,000 | 912 jobs) and Spring ($175,500 | 364 jobs) also feature in the highest pay bracket.
Takeaway: Data engineering roles requiring low-level systems programming or building high-concurrency data infrastructure are paid a significant premium over standard ETL/data-pipelining roles.


2. Infrastructure-as-Code & Cloud Platform Skills Are High-Value AnchorsTerraform boasts an impressive balance of high pay ($184,000) and high volume (3,248 jobs).Kubernetes ($150,500 | 4,202 jobs) and Airflow ($150,000 | 9,996 jobs) represent core data infrastructure pillars that consistently guarantee salaries at or above the $150k threshold.

Takeaway: Overlapping data engineering with DevOps/Platform engineering (DataOps) is one of the clearest paths to higher remote compensation.


3. High Volume vs. Salary Premium Trade-OffAirflow is the single most in-demand specialized skill in this subset (9,996 jobs), anchoring median compensation right at $150,000.Specialized modern database/API frameworks like GraphQL ($167,500) and FastAPI ($157,500) yield higher salaries than broader, ubiquitous tools like MongoDB ($162,250) or Django ($155,000).


4. BI & Legacy Tools Sit at Lower Compensation LevelsBusiness Intelligence tools carry a salary discount compared to engineering/infra tools:Tableau: $115,000 (4,402 jobs)SAS: $115,000 (1,522 jobs)Qlik: $113,792.50 (587 jobs)Legacy scripting & math packages sit near the bottom: VBA ($75,000) and MATLAB ($75,000).
Takeaway: Data Engineers focused strictly on dashboarding, reporting, or legacy scripting earn significantly less than those working on distributed systems and cloud infrastructure.


5. Outliers & Data AnomaliesExpress ($37,500) is a major low-end outlier, likely reflecting offshore job postings or entry-level web development roles miscategorized under Data Engineering.Groovy appears with a NULL median salary, indicating job postings mentioned the skill but lacked reported pay data.Summary MatrixCategoryTop Skill ExamplesMedian Salary RangeStrategic TakeawayHigh-Performance BackendRust, Golang, Spring$175k – $210kNiche, high-concurrency engineeringDevOps & OrchestrationTerraform, Kubernetes, Airflow$150k – $184kCore cloud data infrastructureModern APIs & StorageGraphQL, FastAPI, Neo4j$157k – $170kModern microservice data integrationBusiness IntelligenceTableau, SAS, Qlik$113k – $115kHeavy demand, but lower pay ceilingLegacy ToolsMATLAB, VBA$75kLower market value for Data Engineers


*\



























 