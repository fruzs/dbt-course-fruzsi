# First week assignment

## Q1: How many users do we have?

``` 
SELECT  count(distinct user_id) FROM "stg_user";
```
130 users

## Q2.On average, how many orders do we receive per hour?

```
WITH hourly_orders AS (
SELECT  date_trunc('hours', order_created_at) AS order_hour,
count(distinct order_id) as order_number
FROM "stg_order"
GROUP BY date_trunc('hours', order_created_at) )

SELECT 
 AVG(order_number)
FROM hourly_orders
;
```
8.1
## Q3.On average, how long does an order take from being placed to being delivered?
```
SELECT  AVG(delivered_at - order_created_at)
FROM  "stg_order"
WHERE order_status = 'delivered'
```
"days": 3, "hours": 22, "minutes": 13
## Q4.How many users have only made one purchase? Two purchases? Three+ purchases?
```
WITH purchase_per_user AS (
SELECT user_id, count(order_id)  AS count_orders
FROM stg_order
GROUP BY user_id)

SELECT 
SUM( CASE WHEN count_orders = 1 THEN 1 ELSE 0 END) as "1",
SUM( CASE WHEN count_orders = 2 THEN 1 ELSE 0 END) as  "2",
SUM( CASE WHEN count_orders > 3 THEN 1 ELSE 0 END) AS "3"
FROM purchase_per_user
```
1 order: 25
2 orders: 22
3 or more: 49

## Q5.On average, how many unique sessions do we have per hour?
```
WITH hourly_events AS (
SELECT  date_trunc('hours', event_created_at) AS event_hour,
count(distinct session_id) as session_number
FROM "stg_event_log"
GROUP BY date_trunc('hours', event_created_at) )

SELECT 
 AVG(session_number)
FROM hourly_events
;
```
7.4