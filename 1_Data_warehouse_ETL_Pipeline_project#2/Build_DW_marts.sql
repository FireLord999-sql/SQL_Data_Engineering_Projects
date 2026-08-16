-- duckdb dw_marts.duckdb -c ".read Build_DW_marts.sql" -->to start the pipeline type this in terminal!!!

--STEP_1 CREATE STAR SCHEMA TABLES
.read 01_create_tables_DW.sql

--STEP_2 LOAD DATA INTO STAR SCHEMA TABLES FROM CSV FILES
.read 02_load_schema_DW.sql


--STEP_3 CREATE AND LOAD DATA INTO flat_mart TABLE FROM STAR SCHEMA TABLES
.read 03_Create_flat_mart.sql

----STEP_4 CREATE AND LOAD DATA INTO skills_mart TABLE FROM STAR SCHEMA TABLES
.read 04_Create_skills_mart.sql

----STEP_5 CREATE Priority_mart
.read 05_Priority_mart.sql

----STEP_6 update priority_mart  
.read 06_update_priority_mart.sql