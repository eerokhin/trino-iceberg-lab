SELECT
    report_month,
    department_id,
    COUNT(*) AS row_count
FROM {{ ref('dm_employee_headcount') }}
GROUP BY
    report_month,
    department_id
HAVING COUNT(*) > 1