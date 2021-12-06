{{ config(materialized='table') }}
SELECT user_id
    , user_created_at
    , zipcode
    , state
    , country
FROM {{ref('stg_user')}}
LEFT JOIN {{ref('stg_address')}} USING (address_id)