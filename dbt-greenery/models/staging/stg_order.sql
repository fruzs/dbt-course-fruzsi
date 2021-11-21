{{ config(materialized='table') }}

select
  order_id,
  created_at as order_created_at,
  user_id,
  promo_id,
  address_id,
  order_cost,
  shipping_cost,
  order_total,
  tracking_id,
  shipping_service,
  estimated_delivery_at,
  delivered_at,
  status AS order_status
from {{ source('greenery', 'orders') }}