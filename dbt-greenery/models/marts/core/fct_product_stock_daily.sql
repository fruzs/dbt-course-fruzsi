{{
    config(
        materialized='incremental',
        unique_key='primary_key'
    )
}}
WITH stock_daily AS (
    SELECT 
        product_id
        , order_date 
        , price
        , stock_quantity 
        , sold_quantity 
        , stock_quantity - sold_quantity AS available_quantity
        , CASE 
            WHEN stock_quantity - sold_quantity > 0 
            THEN 'On Stock' 
            ELSE 'Not Available' 
        END AS  stock_status
        , row_number() OVER (PARTITION BY product_id ORDER BY order_date DESC) as rn
    FROM {{ref('stg_product')}}
    LEFT JOIN {{ref('int_sold_product_daily')}} USING (product_id)
)

SELECT product_id
    , order_date 
    , price
    , stock_quantity 
    , sold_quantity
    , available_quantity
    , stock_status
    , CASE 
        WHEN rn = 1 
        THEN TRUE 
        ELSE FALSE 
    END AS is_last_status
    , {{dbt_utils.surrogate_key('product_id', 'order_date')}} as primary_key
FROM stock_daily