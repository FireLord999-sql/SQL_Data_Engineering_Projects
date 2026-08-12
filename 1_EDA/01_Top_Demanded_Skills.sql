/*
Question: What are the most in-demand skills for data engineers?
- Identify the top 10 in-demand skills for data engineers
- Focus on remote job postings
- Why? Retrieves the top 10 skills with the highest demand in the remote jobs
    providing insights into the most valuable skills for data engineers seeking remote roles
*/

select s.skills, count(f.job_id) as Jobs from job_postings_fact f
inner join skills_job_dim sj
on f.job_id = sj.job_id 
inner join skills_dim s
on sj.skill_id=s.skill_id
where f.job_work_from_home IS TRUE and f.job_title_short= 'Data Engineer'
group by s.skills
order by count(f.job_id) desc
limit 10;


┌────────────┬───────┐
│   skills   │ Jobs  │
│  varchar   │ int64 │
├────────────┼───────┤
│ sql        │ 29221 │
│ python     │ 28776 │
│ aws        │ 17823 │
│ azure      │ 14143 │
│ spark      │ 12799 │
│ airflow    │  9996 │
│ snowflake  │  8639 │
│ databricks │  8183 │
│ java       │  7267 │
│ gcp        │  6446 │
└────────────┴───────┘


/* 

key insights:

1. The "Non-Negotiable" Core: SQL & Python are Tied at the Top 

SQL    ████████████████████████████████████████  29,221
Python ███████████████████████████████████████   28,776

The Insight: SQL (29.2k) and Python (28.7k) are in a tier of their own—nearly double the demand of the next closest skill.
What it means: They represent two halves of the same brain:SQL is the language of data transformation and structure (talking to databases).Python is the language of orchestration, scripting, and pipeline building (talking to infrastructure and APIs).You cannot survive in remote Data Engineering without both.

2. The Cloud Provider Hierarchy  
AWS    ███████████████████████  17,823  (Top Cloud)
Azure  ██████████████████       14,143  (Enterprise Standard)
GCP    ████████                  6,446  (Niche/Analytics)


The Insight: AWS leads the pack, with Azure trailing closely behind. GCP sits at the bottom of the top 10.What it means: Cloud infrastructure is where modern data pipelines live. You don't need to learn all three, but mastering AWS or Azure gives you coverage over roughly 80%+ of remote job opportunities.

3. Distributed Compute vs. Modern Data Warehousing  
Big Data Engine:    Spark (12.8k)
Cloud Warehouses:   Snowflake (8.6k) vs. Databricks (8.1k)

Apache Spark is still the undisputed heavy-lifter for massive scale, distributed processing.Snowflake & Databricks are virtually neck-and-neck (~8.6k vs ~8.1k).

What it means: Companies are heavily investing in the "Lakehouse" architecture. Databricks (which runs on Spark) and Snowflake represent the modern standard for storing and processing analytical data.

4. The Orchestration Bottleneck: AirflowAirflow coming in at #6 (almost 10,000 jobs) is a critical signal.What it means: Moving data isn't enough; managing when, how, and in what order data moves (DAGs, dependencies, retry mechanisms) is a core bottleneck in data engineering. Airflow has solidified itself as the industry-standard "scheduler."

5. Enterprise Legacy / Heavy Backend: Java (#9 at 7,267) shows that under the hood, much of big data infrastructure (Hadoop, Kafka, Spark core) is still built on the JVM.What it means: While Python handles day-to-day pipelines, deep performance optimization in massive distributed systems still values object-oriented backend languages like Java/Scala.