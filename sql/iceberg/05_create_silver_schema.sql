/*Создаём iceberg.silver*/
CREATE SCHEMA IF NOT EXISTS iceberg.silver
WITH (
    location = 's3://warehouse/silver/'
);

SHOW SCHEMAS FROM iceberg;