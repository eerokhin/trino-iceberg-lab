/*Перенос employees в Iceberg*/
CREATE TABLE iceberg.bronze.employees
WITH (
    format = 'PARQUET'
)
AS
SELECT
    employee_id,
    first_name,
    last_name,
    email,
    birth_date,
    hire_date,
    termination_date,
    employment_status,
    created_at,
    current_timestamp AS _ingested_at
FROM postgres.public.employees;
