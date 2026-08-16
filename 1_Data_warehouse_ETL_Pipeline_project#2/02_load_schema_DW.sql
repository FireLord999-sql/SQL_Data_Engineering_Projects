



-- INSERT DATA INTO company_dim

select '===  LOADING company_dim table ===' as info;
Insert into company_dim (company_id,name)

select
      company_id,name
from 
      read_csv('https://storage.googleapis.com/sql_de/company_dim.csv',AUTO_DETECT=True);




select '===  LOADING skills_dim table ===' as info;
-- INSERT DATA INTO skills_dim

Insert into skills_dim (skill_id,skills,type)

select
      skill_id,skills,type
from 
      read_csv('https://storage.googleapis.com/sql_de/skills_dim.csv',AUTO_DETECT=True);

select '===  LOADING job_postings_fact table ===' as info;

-- INSERT DATA INTO job_postings_fact

Insert into job_postings_fact (  
   job_id  ,               
 company_id    ,        
 job_title_short ,  
 job_title            ,  
 job_location          ,
 job_via               ,
 job_schedule_type      ,
 job_work_from_home     ,
 search_location       ,
 job_posted_date       ,
 job_no_degree_mention  ,
 job_health_insurance   ,
 job_country            ,
 salary_rate            ,
 salary_year_avg       ,
 salary_hour_avg )

select
 job_id          ,       
 company_id       ,      
 job_title_short   ,    
 job_title          ,   
 job_location        ,   
 job_via              ,  
 job_schedule_type    ,
 job_work_from_home    , 
 search_location        ,
 job_posted_date        ,
 job_no_degree_mention  ,
 job_health_insurance  ,
 job_country           ,
 salary_rate            ,
 salary_year_avg       ,
 salary_hour_avg 
from 
      read_csv('https://storage.googleapis.com/sql_de/job_postings_fact.csv',AUTO_DETECT=True);



select '===  LOADING skills_job_dim table ===' as info;

-- INSERT DATA INTO skills_job_dim

Insert into skills_job_dim (skill_id,job_id)

select
      skill_id,job_id
from 
      read_csv('https://storage.googleapis.com/sql_de/skills_job_dim.csv',AUTO_DETECT=True);

 

-- validating data presence 
select '==== Data presence check =====' as info;


select 'company_dim' as table_name , count(*) as record_count
from company_dim
union all
select 'skills_dim'   , count(*) as record_count
from skills_dim
union all 
select 'skills_job_dim'   , count(*) as record_count
from skills_job_dim
union all
select 'job_postings_fact'  , count(*) as record_count
from job_postings_fact;


 