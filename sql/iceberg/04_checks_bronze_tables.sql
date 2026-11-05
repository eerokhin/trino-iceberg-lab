/*Проверяем результат*/
SELECT COUNT(*)
FROM iceberg.bronze.employees;

SELECT *
FROM iceberg.bronze.employees
ORDER BY employee_id;

/*Проверим snapshot*/
SELECT
    committed_at,
    snapshot_id,
    operation,
    summary
FROM iceberg.bronze."employees$snapshots";
/*{
engine-version=484, 
added-data-files=1, 
total-equality-deletes=0, 
added-records=12, 
trino_query_id=20261105_090754_00016_6jij2, 
total-records=12, 
changed-partition-count=1, 
engine-name=trino, 
manifests-created=1, 
total-position-deletes=0, 
added-files-size=2140, 
total-delete-files=0, 
iceberg-version=Apache Iceberg 1.12.0 (commit 212aa894e919ff9fdf89160da4aadcbe6858ac01), 
manifests-kept=0, 
manifests-replaced=0, 
trino_user=dbt_user, 
total-files-size=2140, 
total-data-files=1
}*/


/*Посмотрим, какой Parquet-файл создал Iceberg*/
SELECT
    file_path,
    file_format,
    record_count,
    file_size_in_bytes
FROM iceberg.bronze."employees$files";

/*Посмотрим историю таблицы*/
SELECT
    made_current_at,
    snapshot_id,
    is_current_ancestor
FROM iceberg.bronze."employees$history";




SHOW TABLES FROM iceberg.bronze;



/*Количество записей во всех пяти таблицах*/
SELECT 'employees' AS table_name, COUNT(*) AS rows_count
FROM iceberg.bronze.employees

UNION ALL

SELECT 'departments', COUNT(*)
FROM iceberg.bronze.departments

UNION ALL

SELECT 'positions', COUNT(*)
FROM iceberg.bronze.positions

UNION ALL

SELECT 'employment_history', COUNT(*)
FROM iceberg.bronze.employment_history

UNION ALL

SELECT 'employee_events', COUNT(*)
FROM iceberg.bronze.employee_events;


SELECT 'employees' AS table_name, COUNT(*) AS rows_count
FROM iceberg.bronze.employees
UNION ALL
SELECT 'departments', COUNT(*)
FROM iceberg.bronze.departments
UNION ALL
SELECT 'positions', COUNT(*)
FROM iceberg.bronze.positions
UNION ALL
SELECT 'employment_history', COUNT(*)
FROM iceberg.bronze.employment_history
UNION ALL
SELECT 'employee_events', COUNT(*)
FROM iceberg.bronze.employee_events;



