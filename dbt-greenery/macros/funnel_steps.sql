{% macro funnel_step(funnel_step,table_name) %}
    SELECT 
      session_id
      , product_id
      , count (*) AS count_{{ funnel_step }}
      FROM {{ table_name }}
      WHERE event_type = '{{ funnel_step }}'
      GROUP BY 1,2

{% endmacro %}