{{ config(materialized='table') }}

WITH month_calendar AS (

    SELECT
        month_start,
        LAST_DAY_OF_MONTH(month_start) AS report_date

    FROM UNNEST(
        SEQUENCE(
            DATE '2020-01-01',
            DATE_ADD(
                'month',
                -1,
                DATE_TRUNC('month', CURRENT_DATE)
            ),
            INTERVAL '1' MONTH
        )
    ) AS t(month_start)

),

department_calendar AS (

    SELECT
        mc.month_start,
        mc.report_date,
        d.department_id,
        d.department_name
    FROM month_calendar mc
    CROSS JOIN {{ ref('stg_departments') }} d

),

headcount_start AS (

    SELECT
        dc.month_start,
        dc.department_id,
        COUNT(DISTINCT e.employee_id) AS headcount_start

    FROM department_calendar dc

    INNER JOIN {{ ref('stg_employment_history') }} eh
        ON eh.department_id = dc.department_id
        AND eh.start_date <= DATE_ADD('day', -1, dc.month_start)
        AND (
            eh.end_date IS NULL
            OR eh.end_date > DATE_ADD('day', -1, dc.month_start)
        )

    INNER JOIN {{ ref('stg_employees') }} e
        ON e.employee_id = eh.employee_id
        AND e.hire_date <= DATE_ADD('day', -1, dc.month_start)
        AND (
            e.termination_date IS NULL
            OR e.termination_date > DATE_ADD('day', -1, dc.month_start)
        )

    GROUP BY
        dc.month_start,
        dc.department_id

),

headcount_end AS (

    SELECT
        dc.month_start,
        dc.department_id,
        COUNT(DISTINCT e.employee_id) AS headcount_end

    FROM department_calendar dc

    INNER JOIN {{ ref('stg_employment_history') }} eh
        ON eh.department_id = dc.department_id
        AND eh.start_date <= dc.report_date
        AND (
            eh.end_date IS NULL
            OR eh.end_date > dc.report_date
        )

    INNER JOIN {{ ref('stg_employees') }} e
        ON e.employee_id = eh.employee_id
        AND e.hire_date <= dc.report_date
        AND (
            e.termination_date IS NULL
            OR e.termination_date > dc.report_date
        )

    GROUP BY
        dc.month_start,
        dc.department_id

),

terminations AS (

    SELECT
        DATE_TRUNC('month', e.termination_date) AS month_start,
        eh.department_id,
        COUNT(DISTINCT e.employee_id) AS termination_count

    FROM {{ ref('stg_employees') }} e

    INNER JOIN {{ ref('stg_employment_history') }} eh
        ON eh.employee_id = e.employee_id
        AND eh.start_date < e.termination_date
        AND (
            eh.end_date IS NULL
            OR eh.end_date = e.termination_date
        )

    WHERE e.termination_date IS NOT NULL

    GROUP BY
        1,
        2

)

SELECT
    dc.month_start AS report_month,
    dc.report_date,
    dc.department_id,
    dc.department_name,

    COALESCE(hs.headcount_start, 0) AS headcount_start,
    COALESCE(he.headcount_end, 0) AS headcount_end,
    COALESCE(t.termination_count, 0) AS termination_count,

    CASE
        WHEN COALESCE(hs.headcount_start, 0)
           + COALESCE(he.headcount_end, 0) = 0
        THEN 0.0

        ELSE
            ROUND(
                100.0 * COALESCE(t.termination_count, 0)
                /
                (
                    COALESCE(hs.headcount_start, 0)
                    + COALESCE(he.headcount_end, 0)
                ) * 2,
                2
            )
    END AS turnover_rate

FROM department_calendar dc

LEFT JOIN headcount_start hs
    ON hs.month_start = dc.month_start
    AND hs.department_id = dc.department_id

LEFT JOIN headcount_end he
    ON he.month_start = dc.month_start
    AND he.department_id = dc.department_id

LEFT JOIN terminations t
    ON t.month_start = dc.month_start
    AND t.department_id = dc.department_id
