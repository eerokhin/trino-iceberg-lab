SELECT *
FROM {{ ref('dm_employee_turnover') }}
WHERE turnover_rate IS NULL