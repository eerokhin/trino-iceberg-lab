SELECT *
FROM {{ ref('dm_employee_turnover') }}
WHERE termination_count > headcount_start