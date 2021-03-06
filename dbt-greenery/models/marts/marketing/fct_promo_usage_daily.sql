{{
    config(
        materialized='incremental',
        unique_key='primary_key'
    )
}}
WITH base AS (
SELECT  p.promo_id
    , o.order_created_at::DATE AS usage_date
    , count(distinct order_id) AS orders_w_promo
FROM {{ref('dim_promo')}}  AS p
LEFT JOIN {{ref('dim_order')}} AS o using (promo_id)
GROUP BY 1,2
)

SELECT 
    * 
    , {{dbt_utils.surrogate_key('promo_id', 'usage_date')}} as primary_key
 FROM base