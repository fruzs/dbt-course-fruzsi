{{ config(materialized='table') }}

WITH base AS
(SELECT user_id
    , user_created_at
    , min(order_created_at) AS first_order_at
    , count(distinct order_id) AS number_of_orders
    , count(distinct CASE WHEN promo_id is not null then order_id else null end) AS number_of_order_w_promo
    , sum(order_total) AS lifetime_revenue
FROM {{ref('stg_user')}}
LEFT JOIN {{ref('stg_order')}} USING(user_id)
GROUP BY 1, 2)

SELECT 
    user_id
    , user_created_at
    , first_order_at
    , first_order_at - user_created_at as time_to_first_orer
    , number_of_orders
    , number_of_order_w_promo
    , lifetime_revenue
FROM base