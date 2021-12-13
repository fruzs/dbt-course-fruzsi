
{{
    config(
        materialized='incremental',
        unique_key='event_id'
    )
}}
WITH base AS (
  SELECT 
    event_id, 
    event_created_at, 
    session_id, 
    user_id, 
    page_url, 
    event_type,
    regexp_split_to_array(page_url, '/') as url_array,
    row_number() OVER (PARTITION BY user_id ORDER BY event_created_at) AS rn
  FROM {{ ref('stg_event_log')}})

SELECT 
  *
  , CASE WHEN url_array[4] = 'product' THEN url_array[5] END as product_id 
FROM base