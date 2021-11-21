{{ config(materialized='table') }}

select
  promo_id,
  discout AS discount,
  status as promo_status
from {{ source('greenery', 'promos') }}