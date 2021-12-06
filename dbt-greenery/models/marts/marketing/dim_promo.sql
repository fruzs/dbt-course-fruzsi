{{ config(materialized='table') }}
SELECT promo_id
    , discount
    , promo_status
FROM {{ref('stg_promo')}}