# Data Engineering Project  Skills Market Analysis

![Project Overview](../Images\1_1_Project1_EDA.png)

> **Manager view:** This project turns remote Data Engineer job-posting data into evidence-based insights about **skill demand, compensation, and estimated ROI**.


> **Analyzing demand, compensation, and estimated ROI of Data Engineering skills in remote job postings using SQL.**

## Quick Navigation

- [Executive Summary](#executive-summary)
- [Key Findings](#key-findings)
- [Analysis 1 — Demand](#analysis-1--most-in-demand-skills)
- [Analysis 2 — Compensation](#analysis-2--highest-paying-skills)
- [Analysis 3 — ROI](#analysis-3--optimal-roi-skills)
- [Methodology](#methodology)
- [Limitations](#important-limitations)
- [Technical Implementation](#technical-implementation)

## Overview

This project analyzes Data Engineering job postings to answer three practical career questions:

1. **Which skills are most in demand for Data Engineers?**
2. **Which skills are associated with the highest median salaries?**
3. **Which skills provide the strongest balance between demand and compensation?**

The analysis focuses specifically on **remote Data Engineering roles** and uses SQL aggregations, joins, filtering, statistical functions, and a custom demand-adjusted ROI metric.

The goal is not simply to produce a list of technologies, but to turn job-market data into **actionable skill-development priorities**.

---

## Business Questions

### 1. What are the most in-demand skills for Data Engineers?

The analysis identifies the top 10 skills appearing most frequently in remote Data Engineer job postings.

### 2. What are the highest-paying skills?

The analysis calculates the median reported annual salary associated with each skill while also considering skill frequency.

### 3. What are the highest-ROI skills?

The analysis combines:

- Median salary
- Skill demand
- A logarithmic transformation of demand

The logarithm reduces the influence of extremely large differences in job volume, preventing highly demanded skills from completely dominating the score.

---

## Executive Summary

The project analyzes **remote Data Engineer job postings** to answer three questions:

| Question | What the analysis measures | Result |
|---|---|---|
| What is most demanded? | Frequency of skill mentions | **SQL and Python lead the market** |
| What is associated with higher pay? | Median reported salary | **Systems/infrastructure skills appear strongly represented at the top** |
| What offers the best demand/pay balance? | Salary × log-transformed demand | **Terraform, Python, SQL, AWS and Airflow rank highly** |

### The main market signal

```text
CORE                 PLATFORM                 INFRASTRUCTURE
SQL + Python   →   Cloud + Airflow   →   Spark/Kafka + Modern Warehouses
                                            ↓
                                  Terraform / Kubernetes
```

**Manager takeaway:** the strongest pattern is not one isolated technology. The market data points toward a layered Data Engineering skillset combining **SQL, Python, cloud, orchestration, distributed processing, data platforms, and infrastructure**.

> The rankings are exploratory associations in the analyzed job postings—not causal proof that a skill itself creates a salary premium.

# Analysis 1 — Most In-Demand Skills

<details>
<summary>🔍 View SQL Query</summary>

```sql
SELECT
    s.skills,
    COUNT(f.job_id) AS Jobs
FROM job_postings_fact f
INNER JOIN skills_job_dim sj
    ON f.job_id = sj.job_id
INNER JOIN skills_dim s
    ON sj.skill_id = s.skill_id
WHERE f.job_work_from_home IS TRUE
  AND f.job_title_short = 'Data Engineer'
GROUP BY s.skills
ORDER BY COUNT(f.job_id) DESC
LIMIT 10;
```

</details>

## Results

| Rank | Skill | Remote Job Postings |
|---:|---|---:|
| 1 | SQL | 29,221 |
| 2 | Python | 28,776 |
| 3 | AWS | 17,823 |
| 4 | Azure | 14,143 |
| 5 | Spark | 12,799 |
| 6 | Airflow | 9,996 |
| 7 | Snowflake | 8,639 |
| 8 | Databricks | 8,183 |
| 9 | Java | 7,267 |
| 10 | GCP | 6,446 |

## Key Findings

### 1. SQL and Python form the dominant core

SQL and Python are substantially ahead of the remaining skills:

- **SQL:** 29,221 postings
- **Python:** 28,776 postings
- **AWS:** 17,823 postings

This indicates that SQL and Python form the strongest foundational skill combination in the analyzed remote Data Engineering market.

### 2. Cloud platforms are highly represented

AWS, Azure, and GCP all appear in the top 10.

AWS leads the three cloud providers in this dataset, followed by Azure and GCP.

### 3. Distributed processing remains important

Apache Spark appears in **12,799** postings, placing it fifth overall.

This indicates continued demand for distributed data-processing capabilities.

### 4. Orchestration is a core Data Engineering responsibility

Airflow appears in **9,996** postings.

This highlights the importance of managing dependencies, scheduling, retries, and workflow execution rather than simply writing individual transformations.

### 5. Modern analytical platforms are strongly represented

Snowflake and Databricks both appear in the top 10, suggesting substantial demand for modern cloud data-platform technologies.

---

# Analysis 2 — Highest-Paying Skills

<details>
<summary>🔍 View SQL Query</summary>

```sql
SELECT
    s.skills AS skill,
    COUNT(j.salary_year_avg) AS Job_Count,
    MEDIAN(j.salary_year_avg) AS Median_Salary
FROM job_postings_fact j
INNER JOIN skills_job_dim sj
    ON j.job_id = sj.job_id
INNER JOIN skills_dim s
    ON sj.skill_id = s.skill_id
WHERE j.job_work_from_home IS TRUE
  AND j.job_title_short LIKE 'Data Engineer'
GROUP BY s.skills
HAVING COUNT(j.job_id) > 100
ORDER BY MEDIAN(j.salary_year_avg) DESC
LIMIT 25;
```

</details>

## Selected Results

| Skill | Job Count | Median Salary |
|---|---:|---:|
| Rust | 23 | $210,000 |
| Golang | 39 | $184,000 |
| Terraform | 193 | $184,000 |
| Spring | 33 | $175,500 |
| Neo4j | 11 | $170,000 |
| GDPR | 22 | $169,615.50 |
| Zoom | 12 | $168,437.50 |
| GraphQL | 28 | $167,500 |
| Mongo | 14 | $162,250 |
| FastAPI | 3 | $157,500 |
| Django | 5 | $155,000 |
| Kubernetes | 147 | $150,500 |
| Airflow | 386 | $150,000 |

## Key Findings

### 1. Systems-oriented technologies appear near the top

Rust, Golang, and Spring are associated with some of the highest median salaries in the extracted results.

This suggests that Data Engineering roles overlapping with backend, infrastructure, and high-performance systems engineering can command strong compensation.

### 2. Infrastructure skills show strong compensation

Terraform, Kubernetes, and Airflow appear prominently.

This points toward an overlap between:

**Data Engineering + Cloud + DevOps/DataOps**

as an important technical specialization.

### 3. Demand and compensation do not always move together

Some skills have very high median salaries but relatively few observations.

For example, Rust has a reported median of **$210K**, but only **23** observations in the displayed output.

Therefore, salary rankings should not be interpreted without considering sample size.

### 4. Some lower-level or legacy tools show lower compensation

The extracted results include lower median salaries for tools such as VBA and MATLAB compared with several modern infrastructure and engineering technologies.

However, salary differences can be influenced by seniority, geography, company type, job function, and other factors.

---

# Analysis 3 — Optimal ROI Skills

## Objective

The third analysis attempts to answer:

> **Which Data Engineering skills provide the strongest balance between compensation and demand?**

Rather than allowing raw job volume to dominate the calculation, demand is transformed using the natural logarithm.

<details>
<summary>🔍 View SQL Query</summary>

```sql
SELECT
    s.skills AS Skills,
    ROUND(MEDIAN(j.salary_year_avg), 2) AS Median_Salary,
    ROUND(LN(COUNT(j.salary_year_avg)), 2) AS Demand,
    ROUND(
        MEDIAN(j.salary_year_avg) *
        LN(COUNT(j.job_id)) / 1000000,
        2
    ) AS Optimal_Score
FROM job_postings_fact j
INNER JOIN skills_job_dim sj
    ON j.job_id = sj.job_id
INNER JOIN skills_dim s
    ON sj.skill_id = s.skill_id
WHERE j.job_title_short LIKE 'Data Engineer'
  AND j.job_work_from_home IS TRUE
  AND j.salary_year_avg IS NOT NULL
GROUP BY s.skills
HAVING COUNT(j.*) > 100
ORDER BY Optimal_Score DESC;
```

</details>

## Results

| Rank | Skill | Median Salary | Log Demand | Optimal Score |
|---:|---|---:|---:|---:|
| 1 | Terraform | $184,000 | 5.26 | 0.97 |
| 2 | Python | $135,000 | 7.03 | 0.95 |
| 3 | SQL | $130,000 | 7.03 | 0.91 |
| 4 | AWS | $137,320.31 | 6.66 | 0.91 |
| 5 | Airflow | $150,000 | 5.96 | 0.89 |
| 6 | Spark | $140,000 | 6.22 | 0.87 |
| 7 | Snowflake | $135,500 | 6.08 | 0.82 |
| 8 | Kafka | $145,000 | 5.68 | 0.82 |
| 9 | Azure | $128,000 | 6.16 | 0.79 |
| 10 | Java | $135,000 | 5.71 | 0.77 |

## Key Findings

### 1. Terraform ranked highest by the custom ROI metric

Terraform achieved the highest Optimal Score at **0.97**, supported by a reported median salary of **$184K**.

### 2. Python provided the strongest demand/compensation balance among foundational skills

Python achieved:

- **$135K median salary**
- **7.03 log-demand score**
- **0.95 Optimal Score**

This makes Python one of the strongest choices when both market demand and compensation are considered.

### 3. SQL remains a high-ROI foundational skill

SQL also achieved a **7.03 demand score** and a **0.91 Optimal Score**.

This reinforces SQL as a foundational skill rather than merely a supporting technology.

### 4. Cloud and orchestration remain strong

AWS and Airflow achieved Optimal Scores of **0.91** and **0.89**, respectively.

### 5. The strongest skillset is multi-layered

The results collectively point toward a stack built around:

```text
SQL
  +
Python
  +
Cloud
  +
Orchestration
  +
Distributed Processing
  +
Modern Data Platforms
```

---

# Methodology

## Data Model

The analysis uses three main tables:

```text
job_postings_fact
        |
        | job_id
        v
skills_job_dim
        |
        | skill_id
        v
skills_dim
```

### `job_postings_fact`

Contains job-level information such as:

- Job ID
- Job title
- Work-from-home status
- Salary information

### `skills_job_dim`

Acts as a bridge table between job postings and skills.

### `skills_dim`

Contains the skill names associated with skill IDs.

---

## SQL Techniques Used

This project demonstrates practical use of:

- `INNER JOIN`
- `GROUP BY`
- `ORDER BY`
- `LIMIT`
- `WHERE`
- `HAVING`
- `COUNT()`
- `MEDIAN()`
- `ROUND()`
- `LN()`
- `IS TRUE`
- `IS NOT NULL`

It also demonstrates analytical concepts including:

- Aggregation
- Filtering
- Ranking
- Median-based analysis
- Logarithmic transformations
- Multi-table relational analysis
- Custom scoring

---

# Why Median Salary?

Median salary was selected instead of average salary because salary distributions can contain extreme values.

For example:

```text
$90K
$100K
$110K
$120K
$1M
```

The average is heavily influenced by the $1M outlier, whereas the median provides a more robust representation of the middle of the distribution.

---

# Why Logarithmic Demand?

Raw demand can differ by orders of magnitude.

For example:

```text
Skill A → 30,000 postings
Skill B → 3,000 postings
```

Using raw demand gives Skill A a 10× advantage.

Using:

```sql
LN(job_count)
```

compresses the difference and introduces diminishing influence from extremely high job counts.

The custom score therefore attempts to balance:

```text
Compensation × Logarithmic Demand
```

rather than allowing raw demand alone to dominate.

---

# Important Limitations

This project is an **exploratory market analysis**, not a causal salary model.

### 1. Association ≠ causation

A high salary associated with a skill does not prove that learning that skill causes a higher salary.

A skill may be correlated with:

- Seniority
- Job level
- Company size
- Geography
- Industry
- Role specialization
- Engineering responsibility

### 2. Skill counts represent job-posting mentions

A skill appearing in a posting indicates that it was associated with that job posting; it does not necessarily indicate how extensively the skill would be used.

### 3. Salary data is incomplete

The ROI analysis deliberately excludes postings where `salary_year_avg` is `NULL`.

Therefore, the salary-based results represent only postings with reported salary information.

### 4. Small samples can create unstable salary rankings

A skill with only a small number of salary observations can show a very high median salary without having enough observations to establish a reliable market-wide estimate.

### 5. The Optimal Score is a custom metric

The Optimal Score was created specifically for this project.

It should be interpreted as a **relative exploratory ranking**, not as an official industry measure of skill value.

---

# Data Quality Note

The displayed salary-analysis output contains some rows whose displayed `Job_Count` values are below the stated `HAVING COUNT(j.job_id) > 100` threshold.

This should be **revalidated against the exact query and dataset state** before presenting the salary ranking as a final production-quality result.

A robust follow-up would verify:

```sql
COUNT(j.job_id)
```

versus:

```sql
COUNT(j.salary_year_avg)
```

and ensure that the intended minimum sample-size condition is being applied consistently.

This validation step is important because **correct SQL execution and correct analytical interpretation are separate concerns**.

---

# Project Takeaways

The analysis suggests that the strongest Data Engineering skill strategy is not based on learning one isolated technology.

Instead, the data points toward a layered skillset:

```text
                    Data Engineering
                           |
             +-------------+-------------+
             |             |             |
            SQL          Python        Cloud
             |             |             |
             +-------------+-------------+
                           |
                    Orchestration
                       Airflow
                           |
              +------------+------------+
              |                         |
        Distributed Compute       Data Platforms
          Spark / Kafka       Snowflake / Databricks
                           |
                    Infrastructure
                 Terraform / Kubernetes
```

The broad conclusion is:

> **Core data skills create the foundation, while cloud, orchestration, distributed systems, and infrastructure skills expand the technical surface area and can be associated with stronger compensation opportunities.**

---

# AI-Assisted Analysis

AI was used **only to assist with generating and refining written interpretations of the SQL results**.

The underlying:

- SQL queries
- joins
- filters
- aggregations
- statistical calculations
- custom ROI formula
- dataset execution
- numerical outputs

were produced and/or executed as part of the project workflow.

AI-generated interpretations were reviewed against the actual query outputs rather than being treated as authoritative.

---

# What This Project Demonstrates

This project demonstrates the ability to:

- Translate business questions into SQL queries
- Work with a relational data model
- Join fact, bridge, and dimension tables
- Filter job-market data
- Perform statistical aggregation
- Compare demand and compensation
- Design a custom analytical metric
- Apply logarithmic transformations
- Interpret analytical results
- Identify limitations and data-quality issues
- Turn raw job-posting data into actionable career insights

---

# Technical Implementation

The README is intentionally **manager-first**. The core implementation is kept behind expandable SQL sections so a hiring manager can understand the project without reading code, while a technical reviewer can inspect the exact queries when needed.

### Data model

```text
job_postings_fact
        │
        │ job_id
        ▼
skills_job_dim
        │
        │ skill_id
        ▼
skills_dim
```

### Recommended repository structure

```text
.
├── README.md
├── assets/
│   └── project-overview.png
└── sql/
    ├── 01_skill_demand.sql
    ├── 02_skill_salary.sql
    └── 03_skill_roi.sql
```

This keeps the README focused on **problem → evidence → insight**, while the SQL remains available for technical inspection.

## Technical Review Path

A technical reviewer can inspect:

1. Relational joins between fact, bridge, and dimension tables
2. Filtering of remote Data Engineer postings
3. Aggregation and ranking logic
4. Median salary calculations
5. Logarithmic demand transformation
6. Custom ROI scoring
7. Sample-size and data-quality controls

## Final Perspective

The project moves beyond simply asking:

> **"What skills are popular?"**

and progresses toward:

> **"What skills appear to provide the best combination of demand and compensation, and how should the results influence skill-development priorities?"**

That progression—from **data retrieval → analysis → modeling → decision support**—is the central objective of this project.
