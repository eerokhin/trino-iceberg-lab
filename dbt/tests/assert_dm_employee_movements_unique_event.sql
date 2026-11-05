SELECT
    event_id,
    COUNT(*) AS row_count
FROM {{ ref('dm_employee_movements') }}
GROUP BY event_id
HAVING COUNT(*) > 1