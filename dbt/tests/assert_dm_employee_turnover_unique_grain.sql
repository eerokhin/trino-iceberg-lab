SELECT
    report_month,
    department_id,
    COUNT(*) AS row_count
FROM {{ ref('dm_employee_turnover') }}
GROUP BY
    report_month,
    department_id
HAVING COUNT(*) > 1