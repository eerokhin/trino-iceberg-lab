{{ config(materialized='table') }}

SELECT
    order_id,
    customer_name,
    amount
FROM iceberg.lab.test_orders