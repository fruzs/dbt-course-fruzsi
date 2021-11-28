{{ config(materialized='table') }}
SELECT order_id
    , order_cost
    , shipping_cost
    , order_total
FROM {{ref('stg_order')}}