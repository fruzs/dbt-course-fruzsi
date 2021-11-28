{{
    config(
        materialized='incremental',
        unique_key='primary_key'
    )
}}


WITH sold_products AS (
SELECT product_id
       , order_created_at::date as order_date
       , SUM(order_item_quantity) AS sold_quantity
FROM {{ref ('stg_order')}} AS o
LEFT JOIN {{ref ('stg_order_item')}} AS oi USING(order_id)
GROUP BY 1,2
)

SELECT *
       , {{dbt_utils.surrogate_key('product_id', 'order_date')}} as primary_key
FROM sold_products