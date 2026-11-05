{{ config(materialized='table') }}

SELECT
    event_id,
    employee_id,
    LOWER(TRIM(event_type)) AS event_type,
    event_date,
    TRIM(description) AS description,
    created_at,
    _ingested_at
FROM {{ source('bronze', 'employee_events') }}