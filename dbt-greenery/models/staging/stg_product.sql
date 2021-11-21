{{ config(materialized='table') }}

select
  product_id,
  name as product_name,
  price,
  quantity as stock_quantity
from {{ source('greenery', 'products') }}