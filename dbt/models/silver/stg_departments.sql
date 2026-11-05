{{ config(materialized='table') }}

SELECT
    department_id,
    TRIM(department_name) AS department_name,
    parent_id,
    created_at,
    _ingested_at
FROM {{ source('bronze', 'departments') }}