-- HR Source: synthetic sample data
-- Execute using the direct PostgreSQL connection: hr_source
-- WARNING: TRUNCATE removes existing rows from these five lab tables.

TRUNCATE TABLE employee_events,
               employment_history,
               employees,
               positions,
               departments
RESTART IDENTITY CASCADE;

INSERT INTO departments (department_id, department_name, parent_id) VALUES
(1, 'Technology', NULL),
(2, 'Data Engineering', 1),
(3, 'Data Science', 1),
(4, 'Human Resources', NULL),
(5, 'Recruitment', 4),
(6, 'Finance', NULL);

INSERT INTO positions (position_id, position_name, job_level) VALUES
(1, 'Junior Data Engineer', 'Junior'),
(2, 'Middle Data Engineer', 'Middle'),
(3, 'Senior Data Engineer', 'Senior'),
(4, 'Data Scientist', 'Middle'),
(5, 'HR Specialist', 'Middle'),
(6, 'Recruiter', 'Middle'),
(7, 'Financial Analyst', 'Middle'),
(8, 'Engineering Manager', 'Lead');

INSERT INTO employees (
    employee_id, first_name, last_name, email,
    birth_date, hire_date, termination_date, employment_status
) VALUES
(1001, 'Ivan', 'Petrov', 'ivan.petrov@example.com', '1995-03-12', '2021-04-12', NULL, 'active'),
(1002, 'Anna', 'Smirnova', 'anna.smirnova@example.com', '1992-07-21', '2020-09-01', NULL, 'active'),
(1003, 'Pavel', 'Sokolov', 'pavel.sokolov@example.com', '1990-11-05', '2019-02-15', NULL, 'active'),
(1004, 'Elena', 'Volkova', 'elena.volkova@example.com', '1997-01-18', '2022-06-20', NULL, 'active'),
(1005, 'Dmitry', 'Kozlov', 'dmitry.kozlov@example.com', '1988-05-30', '2018-03-10', '2023-12-15', 'terminated'),
(1006, 'Maria', 'Orlova', 'maria.orlova@example.com', '1994-09-14', '2021-11-01', NULL, 'active'),
(1007, 'Alexey', 'Morozov', 'alexey.morozov@example.com', '1991-02-25', '2020-01-15', NULL, 'active'),
(1008, 'Olga', 'Lebedeva', 'olga.lebedeva@example.com', '1996-06-08', '2023-02-01', NULL, 'active'),
(1009, 'Sergey', 'Novikov', 'sergey.novikov@example.com', '1989-12-03', '2017-08-14', '2024-06-30', 'terminated'),
(1010, 'Natalia', 'Fedorova', 'natalia.fedorova@example.com', '1993-04-17', '2022-10-10', NULL, 'active'),
(1011, 'Andrey', 'Pavlov', 'andrey.pavlov@example.com', '1998-08-22', '2024-01-15', NULL, 'active'),
(1012, 'Ekaterina', 'Belova', 'ekaterina.belova@example.com', '1995-10-11', '2023-05-02', NULL, 'active');

INSERT INTO employment_history (
    history_id, employee_id, department_id, position_id,
    start_date, end_date, salary, is_current
) VALUES
(1, 1001, 2, 1, '2021-04-12', '2023-04-30', 90000, FALSE),
(2, 1001, 2, 2, '2023-05-01', NULL, 150000, TRUE),
(3, 1002, 2, 2, '2020-09-01', NULL, 170000, TRUE),
(4, 1003, 2, 3, '2019-02-15', NULL, 230000, TRUE),
(5, 1004, 3, 4, '2022-06-20', NULL, 180000, TRUE),
(6, 1005, 2, 2, '2018-03-10', '2023-12-15', 160000, FALSE),
(7, 1006, 5, 6, '2021-11-01', NULL, 130000, TRUE),
(8, 1007, 2, 2, '2020-01-15', '2022-12-31', 140000, FALSE),
(9, 1007, 2, 3, '2023-01-01', NULL, 210000, TRUE),
(10, 1008, 3, 4, '2023-02-01', NULL, 175000, TRUE),
(11, 1009, 6, 7, '2017-08-14', '2024-06-30', 145000, FALSE),
(12, 1010, 4, 5, '2022-10-10', NULL, 120000, TRUE),
(13, 1011, 2, 1, '2024-01-15', NULL, 95000, TRUE),
(14, 1012, 3, 4, '2023-05-02', NULL, 185000, TRUE);

INSERT INTO employee_events (
    event_id, employee_id, event_type, event_date, description
) VALUES
(1, 1001, 'HIRE', '2021-04-12', 'Initial employment'),
(2, 1001, 'PROMOTION', '2023-05-01', 'Promoted to Middle Data Engineer'),
(3, 1005, 'HIRE', '2018-03-10', 'Initial employment'),
(4, 1005, 'TERMINATION', '2023-12-15', 'Voluntary resignation'),
(5, 1007, 'HIRE', '2020-01-15', 'Initial employment'),
(6, 1007, 'PROMOTION', '2023-01-01', 'Promoted to Senior Data Engineer'),
(7, 1009, 'HIRE', '2017-08-14', 'Initial employment'),
(8, 1009, 'TERMINATION', '2024-06-30', 'Employment terminated'),
(9, 1011, 'HIRE', '2024-01-15', 'Initial employment'),
(10, 1012, 'HIRE', '2023-05-02', 'Initial employment');
