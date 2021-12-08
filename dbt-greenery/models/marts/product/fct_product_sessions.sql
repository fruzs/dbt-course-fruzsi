{{ config(materialized='table') }}


WITH prod_session AS (
  SELECT 
    session_id, 
    product_id,
    count(*) as count_page_views
  FROM {{ref('int_event_log')}}
  WHERE product_id IS NOT NULL 
        AND event_type = 'page_view'
  GROUP BY 1,2
)

, add_to_cart AS (
  SELECT 
    session_id
    , product_id
    , count(*) as count_add_to_cart
  FROM {{ref('int_event_log')}}
  WHERE product_id IS NOT NULL 
    AND event_type = 'add_to_cart'
  GROUP BY 1,2
)

, delete_from_cart AS (
  SELECT 
    session_id
    , product_id
    , count(*) as count_delete_from_cart
  FROM {{ref('int_event_log')}}
  WHERE product_id IS NOT NULL 
    AND event_type = 'delete_from_cart'
  GROUP BY 1,2
)


, checkout AS (
  SELECT DISTINCT
    session_id
  FROM {{ref('int_event_log')}}
  WHERE event_type = 'checkout'
)


SELECT 
-- ps.session_id, ps.product_id, count_page_views, count_add_to_cart, count_delete_from_cart
ps.session_id
  , ps.product_id
  , CASE 
      WHEN COALESCE(count_add_to_cart,0) > COALESCE(count_delete_from_cart,0)
      THEN true 
      ELSE false
    END AS is_in_cart
  , CASE 
      WHEN c.session_id IS NOT NULL
      THEN true 
      ELSE false
    END AS is_converted

FROM prod_session ps
LEFT JOIN add_to_cart atc 
  ON atc.session_id = ps.session_id
  AND atc.product_id = ps.product_id
LEFT JOIN delete_from_cart dfc
  ON dfc.session_id = ps.session_id
  AND dfc.product_id = ps.product_id 
LEFT JOIN checkout c 
  ON c.session_id = ps.session_id

