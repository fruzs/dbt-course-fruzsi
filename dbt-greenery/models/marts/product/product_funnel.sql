{{ config(materialized='table') }}

WITH page_view_sessions AS (
    SELECT session_id
    , user_id
    , min(event_created_at) as session_started_at
    FROM {{ref('int_event_log')}}
    WHERE event_type IN ('page_view', 'add_to_cart', 'checkout')
    GROUP BY 1,2
)
, add_to_cart_sessions AS (
    SELECT DISTINCT session_id AS add_to_cart_session_id
    FROM {{ref('int_event_log')}}
    WHERE event_type IN ('add_to_cart', 'checkout')
)
, checkout_sessions AS (
    SELECT DISTINCT session_id  AS checkout_session_id
    FROM {{ref('int_event_log')}}
    WHERE event_type IN ('checkout')
)

SELECT  pvs.session_id
        , session_started_at
        , CASE 
            WHEN add_to_cart_session_id IS NOT NULL 
            THEN true
            ELSE false 
        END AS is_add_to_cart_reached
        , CASE 
            WHEN checkout_session_id IS NOT NULL 
            THEN true
            ELSE false 
        END AS is_checkout_reached
        , user_id
        , product_id

FROM page_view_sessions pvs
LEFT JOIN add_to_cart_sessions AS atcs ON atcs.add_to_cart_session_id = pvs.session_id
LEFT JOIN checkout_sessions AS cs ON cs.checkout_session_id = pvs.session_id
LEFT JOIN {{ref('fct_product_session')}} AS ps ON ps.session_id = pvs.session_id