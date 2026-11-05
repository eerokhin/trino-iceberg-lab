SELECT *
FROM {{ ref('dm_employee_movements') }}
WHERE
    event_id IS NULL
    OR employee_id IS NULL
    OR event_type IS NULL
    OR event_date IS NULL