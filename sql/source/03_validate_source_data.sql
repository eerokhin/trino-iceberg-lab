-- Execute using the direct PostgreSQL connection: hr_source

-- Row counts
SELECT 'departments' AS table_name, COUNT(*) AS rows_count FROM departments
UNION ALL
SELECT 'positions', COUNT(*) FROM positions
UNION ALL
SELECT 'employees', COUNT(*) FROM employees
UNION ALL
SELECT 'employment_history', COUNT(*) FROM employment_history
UNION ALL
SELECT 'employee_events', COUNT(*) FROM employee_events
ORDER BY table_name;

-- Check current employment records
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name,
    p.position_name,
    eh.salary,
    eh.start_date
FROM employees e
JOIN employment_history eh ON e.employee_id = eh.employee_id
JOIN departments d ON eh.department_id = d.department_id
JOIN positions p ON eh.position_id = p.position_id
WHERE eh.is_current = TRUE
ORDER BY e.employee_id;
