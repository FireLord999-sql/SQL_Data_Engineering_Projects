# ⚡ Job Market Data Warehouse & ETL Pipeline

<p align="center">
  <img src="assets/architecture.png" alt="Job Market Data Warehouse Architecture" width="950"/>
</p>

<h3 align="center">
  A modular SQL-based ETL pipeline and analytical data warehouse built with DuckDB.
</h3>

<p align="center">
  <strong>Raw Job Data → Data Warehouse → Analytical Marts → Business-Ready Data</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/DuckDB-FFF000?style=for-the-badge&logo=duckdb&logoColor=black"/>
  <img src="https://img.shields.io/badge/SQL-336791?style=for-the-badge&logo=postgresql&logoColor=white"/>
  <img src="https://img.shields.io/badge/ETL-FF6F00?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Data%20Warehouse-5B2C83?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Dimensional%20Modeling-00897B?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white"/>
</p>

---

## 📌 Project Overview

This project is a complete **SQL-driven ETL and data warehousing pipeline** built with **DuckDB**.

The system takes raw job-market datasets and transforms them into a structured analytical data platform containing:

- A relational data warehouse
- Fact and dimension tables
- A many-to-many bridge table
- A denormalized analytical mart
- A monthly skill-demand mart
- A business-priority mart
- Data validation checks
- Business-rule updates
- `MERGE`-based synchronization
- A modular SQL execution pipeline

The project was built to move beyond writing isolated SQL queries and instead demonstrate the design of an **end-to-end analytical data system**.

---

# 🧭 End-to-End Architecture

<p align="center">
  <img src="assets/architecture.png" alt="End-to-End ETL Architecture" width="950"/>
</p>

```text
                              ┌───────────────────────┐
                              │       RAW DATA        │
                              │                       │
                              │   Job Posting CSVs   │
                              └───────────┬───────────┘
                                          │
                                          ▼
                              ┌───────────────────────┐
                              │      INGESTION        │
                              │                       │
                              │       DuckDB          │
                              │      read_csv()       │
                              └───────────┬───────────┘
                                          │
                                          ▼
                         ┌────────────────────────────────┐
                         │        DATA WAREHOUSE           │
                         │                                │
                         │        Dimensional Model       │
                         └────────────────┬───────────────┘
                                          │
                  ┌───────────────────────┼───────────────────────┐
                  │                       │                       │
                  ▼                       ▼                       ▼
        ┌─────────────────┐     ┌──────────────────┐    ┌───────────────────┐
        │    flat_mart    │     │   skills_mart    │    │   priority_mart   │
        │                 │     │                  │    │                   │
        │ Job-level data  │     │ Skill analytics  │    │ Business rules    │
        └─────────────────┘     └──────────────────┘    └─────────┬─────────┘
                                                                  │
                                                                  ▼
                                                        ┌───────────────────┐
                                                        │       MERGE       │
                                                        │ Synchronization   │
                                                        └─────────┬─────────┘
                                                                  │
                                                                  ▼
                                                        ┌───────────────────┐
                                                        │ ANALYTICS-READY   │
                                                        │       DATA        │
                                                        └───────────────────┘
```

---

# 🎯 Project Goals

The primary objective was to build a reproducible data-engineering workflow using SQL.

### Core objectives

- Build a structured data warehouse from raw CSV datasets
- Implement primary-key and foreign-key relationships
- Model fact, dimension, and bridge tables
- Load source datasets directly into DuckDB
- Transform normalized warehouse data into analytical marts
- Create a dedicated monthly date dimension
- Perform conditional aggregation
- Use DuckDB nested data structures
- Implement business-driven priority rules
- Demonstrate `INSERT`, `UPDATE`, `DELETE`, and `MERGE`
- Synchronize a downstream snapshot with changing source rules
- Validate data throughout the pipeline
- Orchestrate the entire workflow through one SQL entry point

---

# 🏗️ Data Warehouse Architecture

<p align="center">
  <img src="assets/star-schema.png" alt="Data Warehouse Star Schema" width="900"/>
</p>

The core warehouse consists of four tables:

```text
                    ┌────────────────────┐
                    │    company_dim     │
                    ├────────────────────┤
                    │ company_id     PK  │
                    │ name               │
                    └─────────┬──────────┘
                              │
                              ▼
                 ┌──────────────────────────┐
                 │    job_postings_fact     │
                 ├──────────────────────────┤
                 │ job_id             PK    │
                 │ company_id         FK    │
                 │ job_title_short          │
                 │ job_title                 │
                 │ job_location              │
                 │ job_via                   │
                 │ job_schedule_type         │
                 │ job_work_from_home        │
                 │ search_location           │
                 │ job_posted_date           │
                 │ job_no_degree_mention     │
                 │ job_health_insurance      │
                 │ job_country               │
                 │ salary_rate               │
                 │ salary_year_avg           │
                 │ salary_hour_avg           │
                 └─────────────┬────────────┘
                               │
                               ▼
                    ┌────────────────────┐
                    │  skills_job_dim    │
                    ├────────────────────┤
                    │ skill_id       FK  │
                    │ job_id         FK  │
                    │                    │
                    │ Composite PK       │
                    │ (skill_id,job_id)  │
                    └──────────┬─────────┘
                               │
                               ▼
                    ┌────────────────────┐
                    │     skills_dim     │
                    ├────────────────────┤
                    │ skill_id       PK  │
                    │ skills             │
                    │ type               │
                    └────────────────────┘
```

---

# 🧱 Core Warehouse Tables

## 1. `company_dim`

Stores company-level information.

| Column | Data Type | Constraint | Description |
|---|---|---|---|
| `company_id` | `INT` | PK | Unique company identifier |
| `name` | `VARCHAR` | — | Company name |

### SQL definition

```sql
CREATE TABLE company_dim(
    company_id INT PRIMARY KEY,
    name VARCHAR
);
```

---

## 2. `skills_dim`

Stores the skills associated with job postings.

| Column | Data Type | Constraint | Description |
|---|---|---|---|
| `skill_id` | `INT` | PK | Unique skill identifier |
| `skills` | `VARCHAR` | — | Skill name |
| `type` | `VARCHAR` | — | Skill category |

### SQL definition

```sql
CREATE TABLE skills_dim(
    skill_id INT PRIMARY KEY,
    skills VARCHAR,
    type VARCHAR
);
```

---

## 3. `job_postings_fact`

The central fact table containing job-posting information.

| Column | Data Type | Constraint | Description |
|---|---|---|---|
| `job_id` | `INTEGER` | PK | Unique job identifier |
| `company_id` | `INTEGER` | FK | Company reference |
| `job_title_short` | `VARCHAR` | — | Standardized job role |
| `job_title` | `VARCHAR` | — | Original job title |
| `job_location` | `VARCHAR` | — | Job location |
| `job_via` | `VARCHAR` | — | Job source |
| `job_schedule_type` | `VARCHAR` | — | Schedule type |
| `job_work_from_home` | `BOOLEAN` | — | Remote-work indicator |
| `search_location` | `VARCHAR` | — | Search location |
| `job_posted_date` | `TIMESTAMP` | — | Posting timestamp |
| `job_no_degree_mention` | `BOOLEAN` | — | Degree requirement indicator |
| `job_health_insurance` | `BOOLEAN` | — | Health insurance indicator |
| `job_country` | `VARCHAR` | — | Job country |
| `salary_rate` | `VARCHAR` | — | Salary frequency |
| `salary_year_avg` | `DOUBLE` | — | Average annual salary |
| `salary_hour_avg` | `DOUBLE` | — | Average hourly salary |

### SQL definition

```sql
CREATE TABLE job_postings_fact(
    job_id INTEGER PRIMARY KEY,
    company_id INTEGER,
    job_title_short VARCHAR,
    job_title VARCHAR,
    job_location VARCHAR,
    job_via VARCHAR,
    job_schedule_type VARCHAR,
    job_work_from_home BOOLEAN,
    search_location VARCHAR,
    job_posted_date TIMESTAMP,
    job_no_degree_mention BOOLEAN,
    job_health_insurance BOOLEAN,
    job_country VARCHAR,
    salary_rate VARCHAR,
    salary_year_avg DOUBLE,
    salary_hour_avg DOUBLE,

    FOREIGN KEY(company_id)
        REFERENCES company_dim(company_id)
);
```

---

## 4. `skills_job_dim`

A bridge table implementing the many-to-many relationship between jobs and skills.

```text
One Job
   │
   ├── SQL
   ├── Python
   ├── AWS
   └── Spark


One Skill
   │
   ├── Job A
   ├── Job B
   ├── Job C
   └── Job D
```

### SQL definition

```sql
CREATE TABLE skills_job_dim(
    skill_id INT,
    job_id INT,

    PRIMARY KEY(skill_id, job_id),

    FOREIGN KEY(skill_id)
        REFERENCES skills_dim(skill_id),

    FOREIGN KEY(job_id)
        REFERENCES job_postings_fact(job_id)
);
```

The composite primary key:

```text
(skill_id, job_id)
```

prevents the same skill from being associated with the same job more than once.

---

# 🔄 ETL Pipeline

The pipeline is divided into six modular SQL stages.

```text
┌──────────────────────────────────────────────┐
│              ETL PIPELINE                    │
└──────────────────────────────────────────────┘

        ┌────────────────────────────┐
        │ 01 CREATE WAREHOUSE TABLES │
        └─────────────┬──────────────┘
                      │
                      ▼
        ┌────────────────────────────┐
        │ 02 LOAD SOURCE DATA        │
        └─────────────┬──────────────┘
                      │
                      ▼
        ┌────────────────────────────┐
        │ 03 CREATE FLAT MART        │
        └─────────────┬──────────────┘
                      │
                      ▼
        ┌────────────────────────────┐
        │ 04 CREATE SKILLS MART      │
        └─────────────┬──────────────┘
                      │
                      ▼
        ┌────────────────────────────┐
        │ 05 CREATE PRIORITY MART    │
        └─────────────┬──────────────┘
                      │
                      ▼
        ┌────────────────────────────┐
        │ 06 UPDATE PRIORITY MART    │
        │    USING MERGE             │
        └────────────────────────────┘
```

---

# 01️⃣ Create Warehouse Tables

### File

```text
01_create_tables_DW.sql
```

This stage creates the foundational warehouse schema.

It removes existing versions of the tables before rebuilding them:

```sql
DROP TABLE IF EXISTS skills_job_dim;
DROP TABLE IF EXISTS job_postings_fact;
DROP TABLE IF EXISTS company_dim;
DROP TABLE IF EXISTS skills_dim;
```

The warehouse tables are then recreated with primary keys, foreign keys, and the required relationships.

---

# 02️⃣ Load Source Data

### File

```text
02_load_schema_DW.sql
```

The second stage loads the source CSV datasets into the warehouse.

DuckDB's `read_csv()` function is used to read the datasets directly.

## Loading `company_dim`

```sql
INSERT INTO company_dim (
    company_id,
    name
)

SELECT
    company_id,
    name

FROM read_csv(
    'https://storage.googleapis.com/sql_de/company_dim.csv',
    AUTO_DETECT = TRUE
);
```

## Loading `skills_dim`

```sql
INSERT INTO skills_dim (
    skill_id,
    skills,
    type
)

SELECT
    skill_id,
    skills,
    type

FROM read_csv(
    'https://storage.googleapis.com/sql_de/skills_dim.csv',
    AUTO_DETECT = TRUE
);
```

## Loading `job_postings_fact`

```sql
INSERT INTO job_postings_fact(
    job_id,
    company_id,
    job_title_short,
    job_title,
    job_location,
    job_via,
    job_schedule_type,
    job_work_from_home,
    search_location,
    job_posted_date,
    job_no_degree_mention,
    job_health_insurance,
    job_country,
    salary_rate,
    salary_year_avg,
    salary_hour_avg
)

SELECT
    job_id,
    company_id,
    job_title_short,
    job_title,
    job_location,
    job_via,
    job_schedule_type,
    job_work_from_home,
    search_location,
    job_posted_date,
    job_no_degree_mention,
    job_health_insurance,
    job_country,
    salary_rate,
    salary_year_avg,
    salary_hour_avg

FROM read_csv(
    'https://storage.googleapis.com/sql_de/job_postings_fact.csv',
    AUTO_DETECT = TRUE
);
```

## Loading `skills_job_dim`

```sql
INSERT INTO skills_job_dim (
    skill_id,
    job_id
)

SELECT
    skill_id,
    job_id

FROM read_csv(
    'https://storage.googleapis.com/sql_de/skills_job_dim.csv',
    AUTO_DETECT = TRUE
);
```

---

# 🧪 Warehouse Data Validation

After ingestion, the pipeline performs a record-count validation.

```sql
SELECT
    'company_dim' AS table_name,
    COUNT(*) AS record_count
FROM company_dim

UNION ALL

SELECT
    'skills_dim',
    COUNT(*)
FROM skills_dim

UNION ALL

SELECT
    'skills_job_dim',
    COUNT(*)
FROM skills_job_dim

UNION ALL

SELECT
    'job_postings_fact',
    COUNT(*)
FROM job_postings_fact;
```

This provides a quick verification that the expected tables contain data after ingestion.

---

# 📊 Dataset Scale

The project run used a large job-market dataset.

| Table | Records |
|---|---:|
| `company_dim` | **215,940** |
| `skills_dim` | **262** |
| `skills_job_dim` | **7,193,426** |
| `job_postings_fact` | **1,615,930** |

> These figures represent the dataset used during development. If the upstream source data changes, the resulting counts may also change.

---

# 03️⃣ Flat Mart

### File

```text
03_Create_flat_mart.sql
```

The flat mart creates a denormalized analytical representation of job postings.

First, the schema is recreated:

```sql
DROP SCHEMA IF EXISTS flat_mart CASCADE;

CREATE SCHEMA flat_mart;
```

---

# `flat_mart.job_postings`

The transformation combines:

```text
job_postings_fact
       │
       ├──────────────► company_dim
       │
       └──────────────► skills_job_dim
                              │
                              ▼
                         skills_dim
```

The resulting table combines:

- Job information
- Company information
- Salary information
- Remote-work attributes
- Benefits
- Degree requirements
- Skills
- Skill categories

---

## Flat Mart Transformation

```sql
CREATE OR REPLACE TABLE flat_mart.job_postings AS

SELECT
    j.job_id,
    j.company_id,
    j.job_title_short,
    j.job_title,
    j.job_location,
    j.job_via,
    j.job_schedule_type,
    j.job_work_from_home,
    j.search_location,
    j.job_posted_date,
    j.job_no_degree_mention,
    j.job_health_insurance,
    j.job_country,
    j.salary_rate,
    j.salary_year_avg,
    j.salary_hour_avg,

    c.name AS company_name,

    ARRAY_AGG(
        STRUCT_PACK(
            type := s.type,
            name := s.skills
        )
    ) AS skill_and_types

FROM job_postings_fact j

LEFT JOIN company_dim c
    ON j.company_id = c.company_id

LEFT JOIN skills_job_dim sj
    ON j.job_id = sj.job_id

LEFT JOIN skills_dim s
    ON sj.skill_id = s.skill_id

GROUP BY ALL;
```

---

# 🧩 Nested Skill Data

An interesting part of the transformation is the use of DuckDB's nested data capabilities.

Instead of returning several rows for the same job:

```text
Job 1 | SQL
Job 1 | Python
Job 1 | AWS
Job 1 | Spark
```

the flat mart can represent the skills together:

```text
Job 1
│
└── skill_and_types
      │
      ├── SQL      → Programming
      ├── Python   → Programming
      ├── AWS      → Cloud
      └── Spark    → Big Data
```

The aggregation is performed using:

```sql
ARRAY_AGG(
    STRUCT_PACK(
        type := s.type,
        name := s.skills
    )
)
```

This produces a job-level analytical structure while preserving the associated skill categories.

---

# ✅ Flat Mart Validation

```sql
SELECT
    'flat_mart_job_postings' AS table_name,
    COUNT(*) AS entry_count
FROM flat_mart.job_postings;
```

The expected output for the development dataset is approximately:

```text
1,615,930 records
```

---

# 04️⃣ Skills Mart

### File

```text
04_Create_skills_mart.sql
```

The skills mart is designed specifically for **skill-demand analytics over time**.

---

# 🧱 Skills Mart Architecture

```text
                    skills_mart
                         │
             ┌───────────┴───────────┐
             │                       │
             ▼                       ▼
       dim_skills             dim_date_month
             │                       │
             └───────────┬───────────┘
                         │
                         ▼
              fact_skill_demand_monthly
```

---

# `skills_mart.dim_skills`

```sql
CREATE OR REPLACE TABLE skills_mart.dim_skills(
    skill_id INT PRIMARY KEY,
    skills VARCHAR,
    type VARCHAR
);
```

The dimension is populated from the warehouse:

```sql
INSERT INTO skills_mart.dim_skills(
    skill_id,
    skills,
    type
)

SELECT
    skill_id,
    skills,
    type

FROM skills_dim;
```

---

# `skills_mart.dim_date_month`

A dedicated monthly date dimension is created.

```sql
CREATE OR REPLACE TABLE skills_mart.dim_date_month(

    month_start_date DATE PRIMARY KEY,
    year INT,
    month INT,
    quarter INT,
    quarter_name VARCHAR,
    year_quarter VARCHAR

);
```

The dimension derives:

- Month
- Year
- Quarter
- Quarter name
- Year-quarter

from `job_posted_date`.

---

## Date Transformation

```sql
SELECT DISTINCT

    DATE_TRUNC(
        'month',
        job_posted_date
    ) AS month_start_date,

    EXTRACT(
        YEAR FROM job_posted_date
    ) AS year,

    EXTRACT(
        MONTH FROM job_posted_date
    ) AS month,

    EXTRACT(
        QUARTER FROM job_posted_date
    ) AS quarter,

    'Q-' ||
    CAST(
        EXTRACT(
            QUARTER FROM job_posted_date
        ) AS VARCHAR
    ) AS quarter_name,

    year || ' ' || quarter_name
        AS year_quarter

FROM job_postings_fact

ORDER BY month_start_date;
```

---

# `skills_mart.fact_skill_demand_monthly`

The central analytical fact table is:

```sql
CREATE OR REPLACE TABLE skills_mart.fact_skill_demand_monthly (
    skill_id INT,
    month_start_date DATE,
    job_title_short VARCHAR,
    postings_count INT,
    remote_postings_count INT,
    health_insurance_postings_count INT,
    no_degree_mention_postings_count INT,

    PRIMARY KEY (
        skill_id,
        month_start_date,
        job_title_short
    ),

    FOREIGN KEY (month_start_date)
        REFERENCES skills_mart.dim_date_month(month_start_date),

    FOREIGN KEY (skill_id)
        REFERENCES skills_mart.dim_skills(skill_id)
);
```

---

# 📐 Fact Table Grain

The grain of this table is:

```text
Skill
   ×
Month
   ×
Job Title
```

This allows analytical questions such as:

> How many job postings requiring Python existed for Data Engineer roles during a particular month?

or:

> How many remote Data Engineer postings required Spark during a particular quarter?

---

# 📊 Measures

The fact table contains four primary measures:

```text
postings_count
remote_postings_count
health_insurance_postings_count
no_degree_mention_postings_count
```

---

# 🔢 Conditional Aggregation

The transformation first converts boolean attributes into analytical flags.

```sql
CASE
    WHEN j.job_work_from_home = TRUE
    THEN 1
    ELSE 0
END AS is_remote
```

```sql
CASE
    WHEN j.job_health_insurance = TRUE
    THEN 1
    ELSE 0
END AS has_health_insurance
```

```sql
CASE
    WHEN j.job_no_degree_mention = TRUE
    THEN 1
    ELSE 0
END AS no_degree_required
```

These flags are then aggregated:

```sql
COUNT(*) AS postings_count,

SUM(is_remote)
    AS remote_postings_count,

SUM(has_health_insurance)
    AS health_insurance_postings_count,

SUM(no_degree_required)
    AS no_degree_postings_count
```

---

# 🧮 Skills Mart Transformation

```sql
WITH job_postings_prep AS (

    SELECT

        sj.skill_id,

        DATE_TRUNC(
            'month',
            j.job_posted_date
        ) AS month_start_date,

        j.job_title_short,

        CASE
            WHEN j.job_work_from_home = TRUE
            THEN 1
            ELSE 0
        END AS is_remote,

        CASE
            WHEN j.job_health_insurance = TRUE
            THEN 1
            ELSE 0
        END AS has_health_insurance,

        CASE
            WHEN j.job_no_degree_mention = TRUE
            THEN 1
            ELSE 0
        END AS no_degree_required

    FROM job_postings_fact j

    INNER JOIN skills_job_dim sj
        ON sj.job_id = j.job_id
)

SELECT

    skill_id,
    month_start_date,
    job_title_short,

    COUNT(*) AS postings_count,

    SUM(is_remote)
        AS remote_postings_count,

    SUM(has_health_insurance)
        AS health_insurance_postings_count,

    SUM(no_degree_required)
        AS no_degree_postings_count

FROM job_postings_prep

GROUP BY ALL;
```

---

# 05️⃣ Priority Mart

### File

```text
05_Priority_mart.sql
```

The priority mart introduces a business-rule layer into the warehouse.

---

# 🎯 Priority Mart Architecture

<p align="center">
  <img src="assets/data-marts.png" alt="Analytical Data Marts" width="900"/>
</p>

```text
                 job_postings_fact
                         │
                         │
                         ▼
                ┌──────────────────┐
                │ priority_roles   │
                │                  │
                │ role → priority  │
                └────────┬─────────┘
                         │
                         ▼
              priority_jobs_snapshot
```

---

# `priority_mart.priority_roles`

The priority table defines the business importance of different roles.

```sql
CREATE OR REPLACE TABLE priority_mart.priority_roles(
    role_id INT PRIMARY KEY,
    role_name VARCHAR,
    priority_lvl INT
);
```

---

## Initial Business Rules

```text
┌──────────────────────┬──────────────┐
│ Role                 │ Priority     │
├──────────────────────┼──────────────┤
│ Data Engineer        │      4       │
│ Data Scientist       │      1       │
│ Data Analyst         │      7       │
└──────────────────────┴──────────────┘
```

The initial rules are inserted using:

```sql
INSERT INTO priority_mart.priority_roles
VALUES
    (1, 'Data Engineer', 4),
    (2, 'Data Scientist', 1),
    (3, 'Data Analyst', 7);
```

---

# `priority_mart.priority_jobs_snapshot`

The downstream snapshot stores jobs together with their assigned priority.

```sql
CREATE OR REPLACE TABLE priority_mart.priority_jobs_snapshot(

    job_id INT PRIMARY KEY,
    job_title_short VARCHAR,
    company_name VARCHAR,
    job_posted_date DATE,
    salary_year_avg INT,
    priority_lvl INT,
    updated_at TIMESTAMP

);
```

The snapshot is populated by joining:

```text
job_postings_fact
        │
        ├──────────────► company_dim
        │
        └──────────────► priority_roles
```

---

# 06️⃣ Updating the Priority Mart

### File

```text
06_update_priority_mart.sql
```

The sixth stage demonstrates how changing business rules can be propagated to a downstream dataset.

---

# 🔄 Business Rule Changes

## 1. Data Engineer priority changes

```sql
UPDATE priority_mart.priority_roles

SET priority_lvl = 1

WHERE role_name = 'Data Engineer';
```

This changes:

```text
Data Engineer
Priority 4 → Priority 1
```

---

## 2. Senior Data Engineer is added

```sql
INSERT INTO priority_mart.priority_roles(
    role_id,
    role_name,
    priority_lvl
)

VALUES
    (4, 'Senior Data Engineer', 2);
```

New rule:

```text
Senior Data Engineer
Priority → 2
```

---

## 3. Data Analyst is removed

```sql
DELETE FROM priority_mart.priority_roles

WHERE role_name = 'Data Analyst';
```

The resulting business rules become:

```text
┌──────────────────────┬──────────────┐
│ Role                 │ Priority     │
├──────────────────────┼──────────────┤
│ Data Engineer        │      1       │
│ Data Scientist       │      1       │
│ Senior Data Engineer │      2       │
└──────────────────────┴──────────────┘
```

---

# 🔄 Source Table for Synchronization

A temporary source table is created from the updated priority rules.

```sql
CREATE OR REPLACE TEMP TABLE source_table AS

SELECT

    j.job_id,
    j.job_title_short,
    c.name,
    j.job_posted_date,
    j.salary_year_avg,
    p.priority_lvl,
    CURRENT_TIMESTAMP AS updated_at

FROM job_postings_fact j

INNER JOIN priority_mart.priority_roles p
    ON j.job_title_short = p.role_name

INNER JOIN company_dim c
    ON j.company_id = c.company_id;
```

This temporary table becomes the source for the synchronization process.

---

# 🔁 MERGE Synchronization

<p align="center">
  <img src="assets/merge-flow.png" alt="MERGE Synchronization Flow" width="900"/>
</p>

The target:

```text
priority_mart.priority_jobs_snapshot
```

is synchronized against:

```text
source_table
```

using `MERGE`.

---

# 🧠 MERGE Logic

```text
                         SOURCE TABLE
                              │
                              ▼
                           MERGE
                              │
             ┌────────────────┼────────────────┐
             │                │                │
             ▼                ▼                ▼
          MATCHED        NOT MATCHED    NOT MATCHED
             │             BY TARGET       BY SOURCE
             ▼                │                ▼
          UPDATE             INSERT           DELETE
```

### 🟢 MATCHED → UPDATE

If the job exists in both source and target:

```sql
WHEN MATCHED THEN

    UPDATE SET
        priority_lvl = src.priority_lvl
```

The existing job receives the new priority.

### 🔵 NOT MATCHED → INSERT

If a job exists in the source but not in the target:

```sql
WHEN NOT MATCHED THEN

    INSERT (
        job_id,
        job_title_short,
        company_name,
        job_posted_date,
        salary_year_avg,
        priority_lvl,
        updated_at
    )

    VALUES (
        src.job_id,
        src.job_title_short,
        src.name,
        src.job_posted_date,
        src.salary_year_avg,
        src.priority_lvl,
        src.updated_at
    )
```

The new job is inserted.

### 🔴 NOT MATCHED BY SOURCE → DELETE

If a job exists in the target but is no longer represented by the source:

```sql
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
```

This removes stale records.

---

# 🧩 Complete MERGE

```sql
MERGE INTO priority_mart.priority_jobs_snapshot AS tgt

USING source_table AS src

ON tgt.job_id = src.job_id

WHEN MATCHED THEN

    UPDATE SET
        priority_lvl = src.priority_lvl

WHEN NOT MATCHED THEN

    INSERT (
        job_id,
        job_title_short,
        company_name,
        job_posted_date,
        salary_year_avg,
        priority_lvl,
        updated_at
    )

    VALUES (
        src.job_id,
        src.job_title_short,
        src.name,
        src.job_posted_date,
        src.salary_year_avg,
        src.priority_lvl,
        src.updated_at
    )

WHEN NOT MATCHED BY SOURCE THEN

    DELETE;
```

This demonstrates complete source-to-target synchronization:

```text
INSERT + UPDATE + DELETE
```

within a single `MERGE` operation.

---

# 📊 Analytical Data Marts

The warehouse feeds three specialized marts.

```text
                         DATA WAREHOUSE
                                │
              ┌─────────────────┼─────────────────┐
              │                 │                 │
              ▼                 ▼                 ▼
        ┌────────────┐    ┌────────────┐    ┌───────────────┐
        │ flat_mart  │    │skills_mart │    │ priority_mart │
        └──────┬─────┘    └──────┬─────┘    └───────┬───────┘
               │                 │                  │
               ▼                 ▼                  ▼
         Job-level         Skill demand       Business-rule
          analysis           analysis           management
```

---

# 📌 Mart 1 — `flat_mart`

### Purpose

Create a denormalized job-level dataset.

### Main table

```text
flat_mart.job_postings
```

### Contains

- Job information
- Company information
- Salary information
- Remote status
- Benefits
- Degree requirements
- Aggregated skills
- Skill categories

---

# 📌 Mart 2 — `skills_mart`

### Purpose

Analyze skill demand over time.

### Tables

```text
skills_mart.dim_skills
skills_mart.dim_date_month
skills_mart.fact_skill_demand_monthly
```

### Grain

```text
Skill × Month × Job Role
```

### Measures

```text
postings_count
remote_postings_count
health_insurance_postings_count
no_degree_mention_postings_count
```

---

# 📌 Mart 3 — `priority_mart`

### Purpose

Apply business-defined role priorities to job postings.

### Tables

```text
priority_mart.priority_roles
priority_mart.priority_jobs_snapshot
```

### Demonstrates

- Business-rule changes
- Inserts
- Updates
- Deletes
- Source preparation
- Target synchronization
- `MERGE`

---

# 🧪 Data Validation Strategy

Validation is performed throughout the pipeline rather than only at the end.

```text
SOURCE
  │
  ▼
LOAD
  │
  ├── Record count check
  │
  ▼
WAREHOUSE
  │
  ├── Table presence check
  │
  ▼
FLAT MART
  │
  ├── Record reconciliation
  │
  ▼
SKILLS MART
  │
  ├── Dimension presence
  │
  ├── Fact presence
  │
  ▼
PRIORITY MART
  │
  ├── Business rule validation
  │
  └── Snapshot validation
```

---

# 🗂️ Project Structure

```text
job-market-data-warehouse/
│
├── 📄 01_create_tables_DW.sql
├── 📄 02_load_schema_DW.sql
├── 📄 03_Create_flat_mart.sql
├── 📄 04_Create_skills_mart.sql
├── 📄 05_Priority_mart.sql
├── 📄 06_update_priority_mart.sql
│
├── 📄 Build_DW_marts.sql
│
├── 🗄️ dw_marts.duckdb
│
├── 📖 README.md
│
└── 📁 assets/
    ├── architecture.png
    ├── star-schema.png
    ├── data-marts.png
    └── merge-flow.png
```

---

# ⚙️ Pipeline Orchestration

The entire pipeline is orchestrated through:

```text
Build_DW_marts.sql
```

The file acts as the single entry point.

```sql
-- STEP 1
-- CREATE STAR SCHEMA TABLES

.read 01_create_tables_DW.sql


-- STEP 2
-- LOAD DATA INTO STAR SCHEMA TABLES

.read 02_load_schema_DW.sql


-- STEP 3
-- CREATE AND LOAD flat_mart

.read 03_Create_flat_mart.sql


-- STEP 4
-- CREATE AND LOAD skills_mart

.read 04_Create_skills_mart.sql


-- STEP 5
-- CREATE priority_mart

.read 05_Priority_mart.sql


-- STEP 6
-- UPDATE priority_mart

.read 06_update_priority_mart.sql
```

---

# 🚀 How to Run

## 1. Install DuckDB

Install DuckDB from the official website:

https://duckdb.org/

Make sure the `duckdb` executable is available from your terminal.

---

## 2. Clone the Repository

```bash
git clone <YOUR_REPOSITORY_URL>
```

Then:

```bash
cd job-market-data-warehouse
```

---

## 3. Execute the Pipeline

Run:

```bash
duckdb dw_marts.duckdb -c ".read Build_DW_marts.sql"
```

This executes the complete pipeline sequentially.

---

# 🔁 Complete Execution Flow

```text
                    duckdb dw_marts.duckdb
                              │
                              ▼
                    Build_DW_marts.sql
                              │
                              ▼
                ┌─────────────────────────┐
                │ 01_create_tables_DW.sql│
                └────────────┬────────────┘
                             │
                             ▼
                ┌─────────────────────────┐
                │ 02_load_schema_DW.sql   │
                └────────────┬────────────┘
                             │
                             ▼
                ┌─────────────────────────┐
                │ 03_Create_flat_mart.sql │
                └────────────┬────────────┘
                             │
                             ▼
                ┌──────────────────────────┐
                │ 04_Create_skills_mart.sql│
                └────────────┬─────────────┘
                             │
                             ▼
                ┌─────────────────────────┐
                │ 05_Priority_mart.sql    │
                └────────────┬────────────┘
                             │
                             ▼
                ┌─────────────────────────┐
                │ 06_update_priority_mart │
                │          .sql            │
                └─────────────────────────┘
```

---

# 🛠️ Technology Stack

| Technology | Role |
|---|---|
| 🦆 **DuckDB** | Analytical database engine |
| 🧮 **SQL** | Data ingestion, modeling and transformation |
| ⭐ **Dimensional Modeling** | Warehouse architecture |
| 🔗 **Foreign Keys** | Referential integrity |
| 🔄 **MERGE** | Source-to-target synchronization |
| 📄 **CSV** | Source data format |
| 🐙 **Git** | Version control |
| 🐙 **GitHub** | Project hosting |

---

# 🧠 Key Data Engineering Concepts

This project applies a broad set of practical data-engineering concepts.

## Data Modeling

- Fact tables
- Dimension tables
- Bridge tables
- Star schema
- Primary keys
- Foreign keys
- Composite primary keys
- Many-to-many relationships
- Table grain

## SQL

- `SELECT`
- `INSERT`
- `UPDATE`
- `DELETE`
- `MERGE`
- `CREATE TABLE`
- `CREATE SCHEMA`
- `DROP`
- `JOIN`
- `LEFT JOIN`
- `INNER JOIN`
- `GROUP BY`
- `GROUP BY ALL`
- `COUNT`
- `SUM`
- `MIN`
- `CASE`
- `DATE_TRUNC`
- `EXTRACT`
- CTEs
- `ARRAY_AGG`
- `STRUCT_PACK`

## ETL

- Source ingestion
- Data loading
- Transformation
- Data modeling
- Data validation
- Analytical serving
- Pipeline orchestration

## Analytics Engineering

- Analytical marts
- Date dimensions
- Monthly aggregation
- Conditional aggregation
- Denormalization
- Nested data
- Business-rule transformations

## Data Synchronization

- Source tables
- Target tables
- Matched records
- New records
- Stale records
- Update logic
- Insert logic
- Delete logic
- `MERGE`

---

# 🔍 Important Design Concepts

## 1. Table Grain

One of the most important concepts in the project is understanding the grain of each table.

### `job_postings_fact`

```text
One row = One job posting
```

### `skills_job_dim`

```text
One row = One job-skill relationship
```

### `fact_skill_demand_monthly`

```text
One row =
One skill × One month × One job role
```

### `priority_jobs_snapshot`

```text
One row = One prioritized job posting
```

Maintaining the correct grain prevents accidental duplication during joins and aggregations.

---

# 🔗 Many-to-Many Relationship

A job can have many skills.

A skill can belong to many jobs.

Therefore:

```text
JOB
 │
 ├─────────────┐
 │             │
 ▼             ▼
SQL          Python
 │             │
 └──────┬──────┘
        ▼
 skills_job_dim
```

The bridge table resolves the many-to-many relationship.

---

# 📦 Warehouse → Mart Separation

The project intentionally separates the core warehouse from downstream analytical structures.

```text
                     RAW DATA
                        │
                        ▼
                DATA WAREHOUSE
                        │
        ┌───────────────┼───────────────┐
        │               │               │
        ▼               ▼               ▼
     flat_mart      skills_mart    priority_mart
```

### Warehouse layer

Focused on:

- Structure
- Relationships
- Reusable data
- Referential integrity

### Mart layer

Focused on:

- Analytical use cases
- Business logic
- Aggregations
- Consumption

---

# 📈 Why Build a Flat Mart?

The normalized warehouse is useful for structured storage and relationships.

However, analytical consumers often benefit from a more convenient representation.

The flat mart combines:

```text
job_postings_fact
       +
company_dim
       +
skills_job_dim
       +
skills_dim
       ↓
flat_mart.job_postings
```

This makes job-level analysis easier without repeatedly rebuilding the same joins.

---

# 📊 Why Build a Skills Mart?

Skill demand is inherently time-dependent.

The skills mart introduces a monthly analytical grain:

```text
Skill × Month × Role
```

This creates a reusable foundation for analyzing:

- Skill demand
- Remote opportunities
- Benefits
- Degree requirements
- Role-specific trends
- Time-based changes

---

# 🎯 Why Build a Priority Mart?

The priority mart demonstrates that data pipelines are not only about technical transformations.

They can also encode **business rules**.

For example:

```text
Data Engineer
Priority = 1

Senior Data Engineer
Priority = 2
```

These rules can then be propagated into downstream data using `MERGE`.

---

# 🔄 Why Use MERGE?

A `MERGE` statement allows multiple synchronization behaviors to be handled in one operation.

```text
SOURCE                       TARGET
  │                            │
  └──────────── MERGE ─────────┘
               │
       ┌───────┼────────┐
       ▼       ▼        ▼
    UPDATE   INSERT   DELETE
```

This makes the priority snapshot behave like a synchronized downstream representation of the current business rules.

---

# 🧪 Data Quality Philosophy

Validation is treated as part of the pipeline rather than an afterthought.

The pipeline performs checks after major stages:

```text
LOAD
 │
 └── Record counts

WAREHOUSE
 │
 └── Data presence

FLAT MART
 │
 └── Record reconciliation

SKILLS MART
 │
 └── Dimension / fact validation

PRIORITY MART
 │
 └── Snapshot validation
```

---

# 📚 What This Project Demonstrates

This project demonstrates the transition from:

```text
"Writing SQL Queries"
```

to:

```text
"Designing a Data System"
```

The workflow is:

```text
             SOURCE
                │
                ▼
             INGEST
                │
                ▼
              MODEL
                │
                ▼
              LOAD
                │
                ▼
           TRANSFORM
                │
                ▼
            VALIDATE
                │
                ▼
              SERVE
                │
                ▼
            ANALYTICS
```

---

# 🔮 Future Improvements

The current project provides a SQL and DuckDB foundation.

Potential future extensions include:

- [ ] Incremental ingestion
- [ ] Automated data-quality tests
- [ ] Pipeline logging
- [ ] Error handling
- [ ] Retry mechanisms
- [ ] Incremental fact-table processing
- [ ] Apache Airflow orchestration
- [ ] Docker containerization
- [ ] dbt transformations
- [ ] CI/CD pipeline
- [ ] Data lineage
- [ ] BI dashboard
- [ ] Monitoring
- [ ] Alerting
- [ ] Cloud data warehouse deployment
- [ ] Performance benchmarking

---

# 🗺️ Future Architecture

The next evolution of the project could look like:

```text
                         ┌──────────────────┐
                         │   SOURCE DATA    │
                         └────────┬─────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │     AIRFLOW      │
                         │  ORCHESTRATION   │
                         └────────┬─────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │       ETL        │
                         │      / dbt       │
                         └────────┬─────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │ DATA WAREHOUSE   │
                         └────────┬─────────┘
                                  │
                ┌─────────────────┼─────────────────┐
                │                 │                 │
                ▼                 ▼                 ▼
             MART 1             MART 2            MART 3
                │                 │                 │
                └─────────────────┼─────────────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │   BI / ANALYTICS │
                         └──────────────────┘
```

---

# 🏁 Final Database Structure

```text
dw_marts.duckdb
│
├── 🏗️ DATA WAREHOUSE
│   │
│   ├── company_dim
│   ├── skills_dim
│   ├── job_postings_fact
│   └── skills_job_dim
│
├── 📊 flat_mart
│   │
│   └── job_postings
│
├── 📈 skills_mart
│   │
│   ├── dim_skills
│   ├── dim_date_month
│   └── fact_skill_demand_monthly
│
└── 🎯 priority_mart
    │
    ├── priority_roles
    └── priority_jobs_snapshot
```

---

# ⚡ Pipeline at a Glance

```text
┌──────────────────────────────────────────────────────┐
│                    JOB DATA                           │
│                                                      │
│              1,615,930 JOB POSTINGS                  │
│                                                      │
└───────────────────────┬──────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────┐
│                  DATA WAREHOUSE                       │
│                                                      │
│  215,940 Companies                                   │
│  262 Skills                                          │
│  7,193,426 Job-Skill Relationships                   │
│  1,615,930 Job Postings                              │
│                                                      │
└───────────────────────┬──────────────────────────────┘
                        │
          ┌─────────────┼─────────────┐
          ▼             ▼             ▼
       FLAT MART    SKILLS MART   PRIORITY MART
          │             │             │
          ▼             ▼             ▼
       Job-level     Time-based    Business-rule
       analytics      analytics      analytics
                                      │
                                      ▼
                                    MERGE
                                      │
                                      ▼
                                  SYNCHRONIZED
                                    SNAPSHOT
```

---

# 💡 Project Takeaway

The purpose of this project was not simply to create a collection of SQL queries.

The goal was to understand the complete lifecycle of analytical data:

```text
RAW DATA
    ↓
DATA MODELING
    ↓
DATA INGESTION
    ↓
WAREHOUSE
    ↓
TRANSFORMATION
    ↓
DATA MARTS
    ↓
VALIDATION
    ↓
BUSINESS LOGIC
    ↓
SYNCHRONIZATION
    ↓
ANALYTICS-READY DATA
```

This project demonstrates how raw job-market data can be transformed into a structured analytical data platform using SQL and DuckDB.

---

# 👨‍💻 Built With

<p align="center">
  <img src="https://img.shields.io/badge/DuckDB-FFF000?style=for-the-badge&logo=duckdb&logoColor=black"/>
  <img src="https://img.shields.io/badge/SQL-336791?style=for-the-badge&logo=postgresql&logoColor=white"/>
  <img src="https://img.shields.io/badge/ETL-FF6F00?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Data%20Warehouse-5B2C83?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white"/>
</p>

---

<p align="center">
  <strong>RAW DATA → WAREHOUSE → TRANSFORM → VALIDATE → ANALYZE</strong>
</p>

<p align="center">
  ⭐ Built as a hands-on Data Engineering project using SQL & DuckDB.
</p>
