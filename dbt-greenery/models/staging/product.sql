{{ config(materialized='table') }}

select
  *
from {{ source('greenery', 'products') }}