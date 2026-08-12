/*
Question: What are the most optimal ROI skills for data engineers?
(Balance both high pay and high demand for remote roles) *and also cosider lowering weight of demand in case of exponential differnce between skills using natural log of demand.
And also refuse to take into account the demand for jobs where salary is not listed.
*/

PRAGMA table_info(skills_dim);

Select s.skills as Skills , ROUND(median(j.salary_year_avg),2) as Median_Salary , ROUND(LN(count(j.salary_year_avg)),2) as Demand,ROUND((median(j.salary_year_avg)*LN(count(j.job_id))/1000000),2) as Optimal_Score from job_postings_fact j
inner join skills_job_dim sj
on j.job_id=sj.job_id
inner join skills_dim s
on sj.skill_id=s.skill_id
where j.job_title_short like 'Data Engineer'
and j.job_work_from_home IS TRUE
and j.salary_year_avg IS NOT NULL
group by s.skills
having count(j.*)>100
order by Optimal_Score desc;
 




┌────────────┬───────────────┬────────┬───────────────┐
│   Skills   │ Median_Salary │ Demand │ Optimal_Score │
│  varchar   │    double     │ double │    double     │
├────────────┼───────────────┼────────┼───────────────┤
│ terraform  │      184000.0 │   5.26 │          0.97 │
│ python     │      135000.0 │   7.03 │          0.95 │
│ sql        │      130000.0 │   7.03 │          0.91 │
│ aws        │     137320.31 │   6.66 │          0.91 │
│ airflow    │      150000.0 │   5.96 │          0.89 │
│ spark      │      140000.0 │   6.22 │          0.87 │
│ snowflake  │      135500.0 │   6.08 │          0.82 │
│ kafka      │      145000.0 │   5.68 │          0.82 │
│ azure      │      128000.0 │   6.16 │          0.79 │
│ java       │      135000.0 │   5.71 │          0.77 │
│ scala      │     137290.48 │   5.51 │          0.76 │
│ git        │      140000.0 │   5.34 │          0.75 │
│ kubernetes │      150500.0 │   4.99 │          0.75 │
│ databricks │      132750.0 │   5.58 │          0.74 │
│ redshift   │      130000.0 │   5.61 │          0.73 │
│ gcp        │      136000.0 │   5.28 │          0.72 │
│ hadoop     │      135000.0 │   5.29 │          0.71 │
│ nosql      │      134415.0 │   5.26 │          0.71 │
│ pyspark    │      140000.0 │   5.02 │           0.7 │
│ docker     │      135000.0 │   4.97 │          0.67 │
│ mongodb    │      135750.0 │   4.91 │          0.67 │
│ go         │      140000.0 │   4.73 │          0.66 │
│ r          │      134775.0 │   4.89 │          0.66 │
│ bigquery   │      135000.0 │   4.81 │          0.65 │
│ github     │      135000.0 │   4.84 │          0.65 │
│ postgresql │      122500.0 │   4.86 │           0.6 │
│ mysql      │      130500.0 │   4.62 │           0.6 │
│ sql server │      120000.0 │   4.93 │          0.59 │
│ tableau    │      115000.0 │    5.1 │          0.59 │
│ flow       │      125500.0 │   4.67 │          0.59 │
│ oracle     │      124500.0 │   4.69 │          0.58 │
│ power bi   │      120000.0 │   4.86 │          0.58 │
└────────────┴───────────────┴────────┴───────────────┘
  32 rows                                   4 columns

/*
Key Findings:

1.Terraform ranked #1 by Optimal Score, with a $184K median salary and 0.97 score.
2.Python showed the strongest overall balance, with a $135K median salary and the highest demand score of 7.03.
3.SQL matched Python's demand score of 7.03, with a $130K median salary and 0.91 Optimal Score.
4.AWS and Airflow ranked highly, scoring 0.91 and 0.89, respectively.
5.Modern data-platform technologies such as Spark, Kafka, Snowflake, Databricks, Kubernetes, and cloud platforms appeared prominently among the higher-ranked skills.
6.SQL substantially outperformed individual database technologies in this metric: PostgreSQL and MySQL each scored 0.60, compared with SQL's 0.91.
7.BI tools ranked relatively lower, with Tableau at 0.59 and Power BI at 0.58.

Overall, 
the analysis points toward a strong combination of SQL + Python + Cloud + Orchestration + Distributed Processing + Modern Data Platforms as a valuable Data Engineering skillset.

*The results represent associations within the analyzed job postings, not proof that a particular skill directly causes higher salaries.*

*\