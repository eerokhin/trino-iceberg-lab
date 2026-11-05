SHOW TABLES FROM iceberg.gold;


SELECT *
FROM iceberg.gold.dm_employee_headcount
ORDER BY report_date DESC, department_id;





SELECT
    report_month,
    report_date,
    SUM(headcount) AS total_headcount,
    COUNT(*) AS departments_count
FROM iceberg.gold.dm_employee_headcount
GROUP BY
    report_month,
    report_date
ORDER BY report_month DESC
LIMIT 6;


SELECT
    report_date,
    department_id,
    department_name,
    headcount
FROM iceberg.gold.dm_employee_headcount
WHERE report_date = DATE '2026-10-31'
ORDER BY department_id;




DROP TABLE IF EXISTS iceberg.silver.dm_employee_headcount;
SHOW TABLES FROM iceberg.silver;
SHOW TABLES FROM iceberg.gold;

SHOW TABLES FROM iceberg.silver;


SELECT *
FROM iceberg.silver."dm_employee_headcount$history";


select *
from iceberg.silver.stg_employees



select *
from iceberg.silver.stg_employment_history



SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.hire_date,
    e.termination_date,
    eh.department_id,
    d.department_name,
    eh.start_date,
    eh.end_date,
    eh.position_id
FROM iceberg.silver.stg_employees e
JOIN iceberg.silver.stg_employment_history eh
    ON e.employee_id = eh.employee_id
LEFT JOIN iceberg.silver.stg_departments d
    ON eh.department_id = d.department_id
WHERE e.termination_date IS NOT NULL
ORDER BY
    e.employee_id,
    eh.start_date;


SELECT
    DATE_TRUNC('month', termination_date) AS report_month,
    COUNT(*) AS termination_count
FROM iceberg.silver.stg_employees
WHERE termination_date IS NOT NULL
GROUP BY 1
ORDER BY 1;





SELECT
    report_month,
    department_name,
    headcount_start,
    headcount_end,
    termination_count,
    turnover_rate
FROM iceberg.gold.dm_employee_turnover
WHERE termination_count > 0
ORDER BY report_month;



SELECT
    t.report_month,
    t.department_name,

    t.headcount_start,
    COALESCE(hs.headcount, 0) AS expected_start,

    t.headcount_end,
    COALESCE(he.headcount, 0) AS expected_end

FROM iceberg.gold.dm_employee_turnover t

LEFT JOIN iceberg.gold.dm_employee_headcount hs
    ON hs.report_date = DATE_ADD('day', -1, t.report_month)
    AND hs.department_id = t.department_id

LEFT JOIN iceberg.gold.dm_employee_headcount he
    ON he.report_date = t.report_date
    AND he.department_id = t.department_id

WHERE t.termination_count > 0
ORDER BY t.report_month;


SHOW TABLES FROM iceberg.gold;