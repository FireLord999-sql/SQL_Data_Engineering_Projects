-- UPDATE priority_roles_mart
select '==== updating priority_roles table ====' as info;

-- update data enginner to priority 1  (from 4)
update priority_mart.priority_roles
set priority_lvl = 1
where role_name = 'Data Engineer';


-- add senior data engineer as  priority 2

insert into priority_mart.priority_roles
(role_id,role_name,priority_lvl)
values 
(4,'Senior Data Engineer',2);


-- remove data analyst 

delete from priority_mart.priority_roles
where role_name = 'Data Analyst';


select '==== loading priority_roles(updated) table ====' as info;

select * from priority_mart.priority_roles;



create or replace temp table source_table as
select
      j.job_id  ,
    j.job_title_short ,
    c.name  ,
    j.job_posted_date  ,
    j.salary_year_avg  ,
    p.priority_lvl  ,
    CURRENT_TIMESTAMP as updated_at
 

from job_postings_fact j 
inner join priority_mart.priority_roles p
on j.job_title_short = p.role_name
inner join company_dim c
on j.company_id=c.company_id;

 


 -- update priority_jobs_snapshot table by Loading priority_roles table's data(updated) into it
 merge into priority_mart.priority_jobs_snapshot as tgt
using source_table as src
 on tgt.job_id=src.job_id

 when matched then
 update set priority_lvl=src.priority_lvl

 when not matched then
 Insert (job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at )
    
    values(
        src.job_id,
    src.job_title_short,
    src.name,
    src.job_posted_date,
    src.salary_year_avg,
    src.priority_lvl,
    src.updated_at 
    )

when not matched by SOURCE then 
delete ;




select '===== DATA CHECK: loading updated priority_jobs_snapshot table (10 rows) ......... =====' as info;


select 
job_title_short,
count(*) as job_count, 
min(priority_lvl) ,
MIN(updated_at)  
from priority_mart.priority_jobs_snapshot
group by job_title_short
limit 10;