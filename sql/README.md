# HR Lakehouse — SQL-скрипты

SQL-скрипты локального проекта HR Lakehouse.

## Порядок выполнения скриптов

1. `source/01_create_source_tables.sql` — создание исходных таблиц в PostgreSQL. Выполнять через прямое подключение `hr_source`.
2. `source/02_load_sample_data.sql` — загрузка синтетических тестовых данных в PostgreSQL. Выполнять через то же подключение.
3. `source/03_validate_source_data.sql` — проверка количества записей, связей и корректности исходных данных.
4. `checks/01_validate_postgres_catalog.sql` — проверка доступности PostgreSQL и его таблиц через Trino.
5. `iceberg/01_create_bronze_schema.sql` — создание схемы Bronze в Iceberg через Trino.

## Подключения

- **PostgreSQL Source:** `hr_source`
  - Хост: `localhost`
  - Порт: `5433`
  - База данных: `hr_source`
  - Пользователь: `lab`
- **Trino:** `localhost:8080`
- **Iceberg Catalog:** `iceberg`

## Описание проекта

В проекте используется синтетический набор HR-данных. Он не содержит реальных персональных данных.

Основные исходные таблицы:

- `departments` — подразделения компании;
- `positions` — должности сотрудников;
- `employees` — основная информация о сотрудниках;
- `employment_history` — история трудоустройства и кадровых перемещений;
- `employee_events` — кадровые события.

## Важные замечания

- Скрипт `02_load_sample_data.sql` перед загрузкой выполняет `TRUNCATE` пяти исходных таблиц. При повторном запуске существующие тестовые данные будут удалены и загружены заново.
- Скрипт `01_create_bronze_schema.sql` создаёт схему `iceberg.bronze` с расположением данных `s3://warehouse/bronze/` в MinIO.
- На текущем этапе создаётся только схема Bronze. Перенос данных из PostgreSQL в Iceberg будет реализован отдельно на следующем этапе.
- Для первоначальной загрузки данных планируется использовать Trino CTAS — создание Iceberg-таблиц на основе запросов к PostgreSQL.

## Целевая архитектура

```text
PostgreSQL (HR Source)
        |
        v
      Trino
        |
        v
   Iceberg Bronze
        |
        v
   Iceberg Silver
        |
        v
    Iceberg Gold
        |
        v
   HR Data Marts
```

Оркестрация процессов будет реализована с помощью Apache Airflow, а SQL-трансформации — с помощью dbt.
