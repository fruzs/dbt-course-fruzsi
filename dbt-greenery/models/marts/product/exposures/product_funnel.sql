{{ config(materialized='table') }}

WITH page_view_sessions AS (
    SELECT session_id
    , user_id
    , min(event_created_at) as session_started_at
    FROM {{ref('int_event_log')}}
    WHERE event_type IN ('page_view', 'add_to_cart', 'checkout')
    GROUP BY 1,2
)
, cart_sessions AS (
    SELECT DISTINCT session_id AS cart_session_id
    FROM {{ref('int_event_log')}}
    WHERE event_type IN ('add_to_cart', 'checkout')
)
, checkout_sessions AS (
    SELECT DISTINCT session_id  AS checkout_session_id
    FROM {{ref('int_event_log')}}
    WHERE event_type IN ('checkout')
)

, product_funnel AS(
SELECT  pvs.session_id
        , session_started_at
        , cart_session_id
        , checkout_session_id
        , user_id
        , product_id

FROM page_view_sessions pvs
LEFT JOIN cart_sessions AS atcs ON atcs.cart_session_id = pvs.session_id
LEFT JOIN checkout_sessions AS cs ON cs.checkout_session_id = pvs.session_id
LEFT JOIN {{ref('fct_product_session')}} AS ps ON ps.session_id = pvs.session_id)

SELECT count(session_id) as nr_page_view_sessions
    , count(cart_session_id) as nr_cart_sessions
    , count(checkout_session_id) as nr_checkout_sessions
    , count(cart_session_id)::dec/count(session_id)::dec as page_view_to_cart_dropoff
    , count(checkout_session_id)::dec / count(cart_session_id)::dec as cart_to_checkout_dropoff
FROM product_funnel