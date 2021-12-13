{{ config(materialized='table') }}

WITH funnel_steps AS
(SELECT log1.user_id
    , log1.event_created_at
    , log1.event_type as funnel_step
    , log2.event_type as next_funnel_step
FROM {{ref('int_event_log')}} AS log1
LEFT JOIN {{ref('int_event_log')}} AS log2 
    ON log1.user_id = log2.user_id
    AND log1.rn = log2.rn-1)

SELECT  date_trunc('month',user_created_at)::date as user_signup_monthly_cohorts
    , funnel_step
    , next_funnel_step
    , count(user_id) count_users
FROM funnel_steps
LEFT JOIN {{ref('dim_user')}} USING (user_id) 
GROUP BY 1,2,3
ORDER BY 1,4