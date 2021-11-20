{{ config(materialized='table') }}

select
  *
from {{ source('greenery', 'order_items') }}