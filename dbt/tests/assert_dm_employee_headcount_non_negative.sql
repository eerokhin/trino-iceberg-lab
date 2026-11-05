SELECT *
FROM {{ ref('dm_employee_headcount') }}
WHERE headcount < 0