{{ config(materialized='table') }}

SELECT
    employee_id,
    TRIM(first_name) AS first_name,
    TRIM(last_name) AS last_name,
    LOWER(TRIM(email)) AS email,
    birth_date,
    hire_date,
    termination_date,
    LOWER(TRIM(employment_status)) AS employment_status,
    created_at,
    _ingested_at

FROM {{ source('bronze', 'employees') }}