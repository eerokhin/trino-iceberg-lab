SELECT *
FROM {{ ref('dm_employee_turnover') }}
WHERE
    headcount_start < 0
    OR headcount_end < 0
    OR termination_count < 0