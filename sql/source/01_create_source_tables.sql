-- HR Source: PostgreSQL DDL
-- Execute using the direct PostgreSQL connection: hr_source

CREATE TABLE IF NOT EXISTS departments (
    department_id   BIGINT PRIMARY KEY,
    department_name VARCHAR(150) NOT NULL,
    parent_id       BIGINT REFERENCES departments(department_id),
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS positions (
    position_id   BIGINT PRIMARY KEY,
    position_name VARCHAR(150) NOT NULL,
    job_level     VARCHAR(50),
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS employees (
    employee_id       BIGINT PRIMARY KEY,
    first_name        VARCHAR(100) NOT NULL,
    last_name         VARCHAR(100) NOT NULL,
    email             VARCHAR(255),
    birth_date        DATE,
    hire_date         DATE NOT NULL,
    termination_date  DATE,
    employment_status VARCHAR(30) NOT NULL,
    created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS employment_history (
    history_id    BIGINT PRIMARY KEY,
    employee_id   BIGINT NOT NULL REFERENCES employees(employee_id),
    department_id BIGINT NOT NULL REFERENCES departments(department_id),
    position_id   BIGINT NOT NULL REFERENCES positions(position_id),
    start_date    DATE NOT NULL,
    end_date      DATE,
    salary        NUMERIC(12, 2),
    is_current    BOOLEAN NOT NULL DEFAULT FALSE,
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (end_date IS NULL OR end_date >= start_date),
    CHECK (salary IS NULL OR salary >= 0)
);

CREATE TABLE IF NOT EXISTS employee_events (
    event_id    BIGINT PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(employee_id),
    event_type  VARCHAR(50) NOT NULL,
    event_date  DATE NOT NULL,
    description TEXT,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_employment_history_employee
    ON employment_history(employee_id);

CREATE INDEX IF NOT EXISTS idx_employment_history_department
    ON employment_history(department_id);

CREATE INDEX IF NOT EXISTS idx_employee_events_employee
    ON employee_events(employee_id);

CREATE INDEX IF NOT EXISTS idx_employee_events_date
    ON employee_events(event_date);
