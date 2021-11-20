{{
config(sort_type='compound',
            sort=['session_id','user_id'],
            dist='session_id',
            materialized='table')
}}

select
  *
from {{ source('greenery', 'events') }}
