
{{ config(materialized='table') }}

WITH month_calendar AS (

    SELECT
        month_start,
        LAST_DAY_OF_MONTH(month_start) AS report_date
    FROM UNNEST(
        SEQUENCE(
            DATE '2020-01-01',
            DATE_ADD('month', -1, DATE_TRUNC('month', CURRENT_DATE)),
            INTERVAL '1' MONTH
        )
    ) AS t(month_start)

),

department_calendar AS (

    SELECT
        mc.month_start AS report_month,
        mc.report_date,
        d.department_id,
        d.department_name

    FROM month_calendar mc

    CROSS JOIN {{ ref('stg_departments') }} d

),

headcount AS (

    SELECT
        mc.month_start AS report_month,
        eh.department_id,
        COUNT(DISTINCT eh.employee_id) AS headcount

    FROM month_calendar mc

    INNER JOIN {{ ref('stg_employment_history') }} eh
        ON eh.start_date <= mc.report_date
        AND (
            eh.end_date IS NULL
            OR eh.end_date > mc.report_date
        )

    INNER JOIN {{ ref('stg_employees') }} e
        ON eh.employee_id = e.employee_id
        AND e.hire_date <= mc.report_date
        AND (
            e.termination_date IS NULL
            OR e.termination_date > mc.report_date
        )

    GROUP BY
        mc.month_start,
        eh.department_id

)

SELECT
    dc.report_month,
    dc.report_date,
    dc.department_id,
    dc.department_name,
    COALESCE(h.headcount, 0) AS headcount

FROM department_calendar dc

LEFT JOIN headcount h
    ON dc.report_month = h.report_month
    AND dc.department_id = h.department_id
