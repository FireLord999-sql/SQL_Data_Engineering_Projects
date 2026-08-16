--CREATE skills demand mart

drop schema if exists skills_mart CASCADE;

create schema skills_mart;

create or replace table skills_mart.dim_skills(
skill_id INT PRIMARY KEY ,
skills varchar,
type varchar
);
insert into skills_mart.dim_skills(
    skill_id,
    skills,
    type
)
select
skill_id,
skills,
type
from skills_dim;

  --dim_date_month (year, month, quarter,quarter_name,year_quarter)
create  or replace table   skills_mart.dim_date_month(

month_start_date date primary key,
year int,
month int,
quarter int,
quarter_name varchar,
year_quarter varchar

);
insert into skills_mart.dim_date_month(
    month_start_date,year,month,quarter,quarter_name,year_quarter
)

  select distinct

    DATE_TRUNC('month',job_posted_date) as month_start_date,
    extract(year from job_posted_date) as year,
    extract(month from job_posted_date) as month,
    extract(quarter from job_posted_date) as quarter,
    'Q-'|| cast(extract(quarter from job_posted_date) as varchar) as quarter_name,
    year||' '  ||  quarter_name as year_quarter
from job_postings_fact
order by month_start_date;


select '==== DATA PRESENCE CHECK ====' AS info;

   
 select '==== LOADINNG dim_skills table ====' as info;
select * from skills_mart.dim_skills;

  select '==== LOADINNG dim_date_month table ====' as info;
  select * from skills_mart.dim_date_month;


  --Column Name Keys / Constraints skill_idPK/FK 
  --month_start_date PK/ FK job_title_shortPK 
  --Attributes:postings_count
  --remote_postings_count
 -- health_insurance_postings_count
  --no_degree_postings_count

CREATE OR REPLACE TABLE skills_mart.fact_skill_demand_monthly (
    skill_id INT,
    month_start_date DATE,
    job_title_short VARCHAR,
    postings_count INT,
    remote_postings_count INT,
    health_insurance_postings_count INT,
    no_degree_mention_postings_count INT,
    PRIMARY KEY (skill_id, month_start_date, job_title_short),
    foreign key (month_start_date) references skills_mart.dim_date_month(month_start_date),
    FOREIGN KEY (skill_id) references skills_mart.dim_skills(skill_id)
);

INSERT INTO skills_mart.fact_skill_demand_monthly
 
 
 with job_postings_prep as ( 

  select sj.skill_id,DATE_TRUNC('month',j.job_posted_date) as month_start_date,j.job_title_short,
  case when j.job_work_from_home = TRUE then 1 else 0 end as is_remote,
  case when j.job_health_insurance = TRUE then 1 else 0 end as has_health_insurance,
  case when j.job_no_degree_mention = TRUE then 1 else 0 end as no_degree_required
  from job_postings_fact j
  inner join skills_job_dim sj
  on sj.job_id=j.job_id

 )
 select 
 skill_id,
 month_start_date,
 job_title_short,
 count(*) as postings_count ,
 sum(is_remote) as remote_postings_count,
 sum(has_health_insurance) as health_insurance_postings_count,
 sum(no_degree_required) as no_degree_postings_count
 
 from job_postings_prep
   
 
  group by all;

  select '==== DATA ENTRY CHECK =====' AS info;

  select * from skills_mart.fact_skill_demand_monthly
limit 10;
 
 