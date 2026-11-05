SELECT *
FROM {{ ref('dm_employee_movements') }}
WHERE event_type NOT IN (
    'hire',
    'promotion',
    'termination'
)