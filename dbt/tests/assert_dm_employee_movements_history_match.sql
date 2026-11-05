WITH history_matches AS (

    SELECT
        ev.event_id,
        COUNT(eh.history_id) AS match_count

    FROM {{ ref('stg_employee_events') }} ev

    LEFT JOIN {{ ref('stg_employment_history') }} eh
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

    GROUP BY ev.event_id

)

SELECT *
FROM history_matches
WHERE match_count <> 1