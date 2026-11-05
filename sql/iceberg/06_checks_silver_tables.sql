/*Проверяем результат в Trino*/
SELECT
    'bronze' AS layer,
    COUNT(*) AS rows_count
FROM iceberg.bronze.employees
UNION ALL
SELECT
    'silver' AS layer,
    COUNT(*) AS rows_count
FROM iceberg.silver.stg_employees;




/*Сами данные*/
SELECT *
FROM iceberg.silver.stg_employees
ORDER BY employee_id;




/*метаданные Iceberg*/
SELECT *
FROM iceberg.silver."stg_employees$snapshots";





SELECT 'employees' AS table_name, COUNT(*) AS rows_count
FROM iceberg.silver.stg_employees
UNION ALL
SELECT 'departments', COUNT(*)
FROM iceberg.silver.stg_departments
UNION ALL
SELECT 'positions', COUNT(*)
FROM iceberg.silver.stg_positions
UNION ALL
SELECT 'employment_history', COUNT(*)
FROM iceberg.silver.stg_employment_history
UNION ALL
SELECT 'employee_events', COUNT(*)
FROM iceberg.silver.stg_employee_events
ORDER BY table_name;







SELECT *
FROM iceberg.silver.stg_employees