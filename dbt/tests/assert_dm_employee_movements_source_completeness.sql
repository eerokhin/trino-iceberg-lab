SELECT
    ev.event_id
FROM {{ ref('stg_employee_events') }} ev

LEFT JOIN {{ ref('dm_employee_movements') }} dm
    ON ev.event_id = dm.event_id

WHERE dm.event_id IS NULL