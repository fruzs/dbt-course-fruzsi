{{
config(sort_type='compound',
            sort=['session_id','user_id'],
            dist='session_id',
            materialized='table')
}}

select
  event_id,
  created_at as event_created_at,
  session_id,
  user_id,
  page_url,
  event_type
from {{ source('greenery', 'events') }}
