-- CREATE FLAT MART TABLE

drop schema if exists flat_mart CASCADE;

create schema flat_mart;
select '===loading flat_mart ===='as info;
create or replace table flat_mart.job_postings as 
select 
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
c.name as company_name,
c.company_id,
ARRAY_AGG( 
STRUCT_PACK(
    type:=s.type,
    name:=s.skills
)
) AS skill_and_types

from job_postings_fact j
left join company_dim c
on j.company_id=c.company_id
left join skills_job_dim sj 
on j.job_id=sj.job_id
LEFT JOIN skills_dim s
on sj.skill_id=s.skill_id

GROUP BY ALL;

select '==== DATA VALIDATION CHECK ===' AS info;

select 'flat_mart_job_postings' as table_name, count(*) as entry_count
from flat_mart.job_postings;