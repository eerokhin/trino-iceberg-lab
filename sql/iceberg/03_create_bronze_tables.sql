-- 1. Departments
CREATE TABLE iceberg.bronze.departments
WITH (format = 'PARQUET')
AS
SELECT
    department_id,
    department_name,
    parent_id,
    created_at,
    current_timestamp AS _ingested_at
FROM postgres.public.departments;


-- 2. Positions
CREATE TABLE iceberg.bronze.positions
WITH (format = 'PARQUET')
AS
SELECT
    position_id,
    position_name,
    job_level,
    created_at,
    current_timestamp AS _ingested_at
FROM postgres.public.positions;


-- 3. Employment History
CREATE TABLE iceberg.bronze.employment_history
WITH (format = 'PARQUET')
AS
SELECT
    history_id,
    employee_id,
    department_id,
    position_id,
    start_date,
    end_date,
    salary,
    is_current,
    created_at,
    current_timestamp AS _ingested_at
FROM postgres.public.employment_history;


-- 4. Employee Events
CREATE TABLE iceberg.bronze.employee_events
WITH (format = 'PARQUET')
AS
SELECT
    event_id,
    employee_id,
    event_type,
    event_date,
    description,
    created_at,
    current_timestamp AS _ingested_at
FROM postgres.public.employee_events;
