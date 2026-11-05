{{ config(materialized='table') }}

SELECT
    position_id,
    TRIM(position_name) AS position_name,
    LOWER(TRIM(job_level)) AS job_level,
    created_at,
    _ingested_at
FROM {{ source('bronze', 'positions') }}