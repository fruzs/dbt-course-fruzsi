{{
    config(
        materialized='incremental',
        unique_key='event_id'
    )
}}


SELECT   event_id,
  event_created_at,
  session_id,
  user_id,
  page_url
FROM {{ref('stg_event_log')}}
WHERE event_type = 'page_view'