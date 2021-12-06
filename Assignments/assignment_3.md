#Third Week assignment
I taken into account that when the product is removed from the cart more times than added in the same session, then there is no conversion. 

This way the conversion rate overall:
```
WITH base AS (SELECT count(distinct session_id) as nr_of_sessions,
count (distinct case when is_converted is true then session_id else null end) AS nr_conversions
FROM "fct_product_sessions" )
SELECTFROM base

```


answer 60%


on product level:
```
WITH base AS (SELECT count(distinct session_id) as nr_of_sessions,
count (distinct case when is_converted is true then session_id else null end) AS nr_conversions
FROM "fct_product_sessions" 
GROUP BY 1)
SELECT product_id, nr_conversions ::dec/ nr_of_sessions::dec*100 as conversion_rate
FROM base

```
