{{ config(materialized='table') }}

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
    _ingested_at
FROM {{ source('bronze', 'employment_history') }}