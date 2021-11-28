{{ config(materialized='table') }}
SELECT order_id
    , user_id
    , promo_id
    , order_created_at
    , shipping_service
    , delivered_at
    , order_status

FROM {{ref('stg_order')}}