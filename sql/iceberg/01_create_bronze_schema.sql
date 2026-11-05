/*Создаём схему Bronze*/
CREATE SCHEMA IF NOT EXISTS iceberg.bronze
WITH (
    location = 's3://warehouse/bronze/'
);

/*Проверяем создание*/
SHOW SCHEMAS FROM iceberg;
SHOW TABLES FROM iceberg.bronze;
