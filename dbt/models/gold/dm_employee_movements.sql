
{{ config(materialized='table') }}

WITH events AS (

    SELECT
        event_id,
        employee_id,
        event_type,
        event_date,
        description

    FROM {{ ref('stg_employee_events') }}

),

history_with_previous AS (

    SELECT
        eh.*,

        LAG(eh.position_id) OVER (
            PARTITION BY eh.employee_id
            ORDER BY eh.start_date
        ) AS previous_position_id

    FROM {{ ref('stg_employment_history') }} eh

),

matched_history AS (

    SELECT
        ev.event_id,
        ev.employee_id,
        ev.event_type,
        ev.event_date,
        ev.description,

        eh.history_id,
        eh.department_id,
        eh.position_id,
        eh.previous_position_id

    FROM events ev

    INNER JOIN history_with_previous eh
        ON eh.employee_id = ev.employee_id
        AND (
            (
                ev.event_type IN ('hire', 'promotion')
                AND eh.start_date = ev.event_date
            )
            OR
            (
                ev.event_type = 'termination'
                AND eh.end_date = ev.event_date
            )
        )

)

SELECT
    m.event_id,
    m.employee_id,
    m.event_type,
    m.event_date,

    m.department_id,
    d.department_name,

    m.position_id,
    p.position_name,

    m.previous_position_id,
    pp.position_name AS previous_position_name,

    m.description

FROM matched_history m

LEFT JOIN {{ ref('stg_departments') }} d
    ON m.department_id = d.department_id

LEFT JOIN {{ ref('stg_positions') }} p
    ON m.position_id = p.position_id

LEFT JOIN {{ ref('stg_positions') }} pp
    ON m.previous_position_id = pp.position_id
