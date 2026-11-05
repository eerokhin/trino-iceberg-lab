-- Execute using the Trino connection in DBeaver.

SHOW CATALOGS;
SHOW SCHEMAS FROM postgres;
SHOW TABLES FROM postgres.public;

SELECT
    employee_id,
    first_name,
    last_name,
    hire_date,
    employment_status
FROM postgres.public.employees
ORDER BY employee_id;

-- Join across PostgreSQL source tables through Trino
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name,
    p.position_name,
    eh.salary,
    eh.start_date
FROM postgres.public.employees e
JOIN postgres.public.employment_history eh
    ON e.employee_id = eh.employee_id
JOIN postgres.public.departments d
    ON eh.department_id = d.department_id
JOIN postgres.public.positions p
    ON eh.position_id = p.position_id
WHERE eh.is_current = TRUE
ORDER BY e.employee_id;
