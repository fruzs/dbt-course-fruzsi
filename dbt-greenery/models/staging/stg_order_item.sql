{{ config(materialized='table') }}

select
  order_id,
  product_id,
  quantity AS order_item_quantity
from {{ source('greenery', 'order_items') }}