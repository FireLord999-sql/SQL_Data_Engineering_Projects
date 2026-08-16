--create priorit roles mart

drop schema if exists priority_mart CASCADE;

create schema priority_mart;


create or replace table priority_mart.priority_roles(
    role_id int primary key,
    role_name varchar,
    priority_lvl int 
);

insert into priority_mart.priority_roles 
values
(1,'Data Engineer',4),
(2,'Data Scientist',1),
(3,'Data Analyst',7);
     
select '==== loading priority_roles table ====' as info;

select * from priority_mart.priority_roles;

create or replace table priority_mart.priority_jobs_snapshot(
   
    job_id int primary key,
    job_title_short varchar ,
    company_name varchar,
    job_posted_date date,
    salary_year_avg int,
    priority_lvl int,
    updated_at TIMESTAMP
 
);
INSERT INTO priority_mart.priority_jobs_snapshot(
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at 
)

select 
j.job_id,
    j.job_title_short,
    c.name,
    j.job_posted_date,
    j.salary_year_avg,
    p.priority_lvl,
    CURRENT_TIMESTAMP

from job_postings_fact j 
inner join priority_mart.priority_roles p
on j.job_title_short = p.role_name
inner join company_dim c
on j.company_id=c.company_id;


select '===== LOADING 10 ROWS OF priority_jobs_snapshot ======' as info;

select * from priority_mart.priority_jobs_snapshot
limit 10;