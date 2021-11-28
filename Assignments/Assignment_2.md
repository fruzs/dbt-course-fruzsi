# (Part 1) Models

### What is our user repeat rate?

Repeat Rate = Users who purchased 2 or more times / users who purchased

```
WITH base AS (
SELECT user_id, count(distinct order_id) as order_count 
FROM stg_user as u
LEFT JOIN stg_order as o USING(user_id)
GROUP BY 1)
SELECT SUM(CASE WHEN order_count>1 THEN 1 ELSE 0 END)/COUNT(user_id)::float
FROM base 
```

The repeat rate is ~ 80%

What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

- The state: my assumption is that in states where there are more land/capita people are more likely to have a house/ purchase plants
- If they used promo code or have unused promo code
- Weather: when it s nicer out theymight be more likely to spend time with gardening.




### Core:
- dim_product: The product dimension, containing name and id
- dim_user: Containing the not sensitive information around the user and address
- dim_order: Basic dimensions of the order
- fct_order: The basic facts around the order
- fct_product_stock_daily: This table shows what s the status of the stock each day when there are orders happening
- int_sold_product_daily: is an intermediate table to calculate how much product is sold on daily level

### Marketing:
- dim_promo: The basic dimensions of a promotion
- fct_promo_usage: Calculates how many orders the promotion is used per day, which can indicate the success of the marketing campaign
- fct_user_order: Calculates how many orders a user has, how long it takes for the first order after user creation and also how many revenue the orders generate

### Product
- fct_page_views: how many pageviews happen on the website





# (Part 2) Tests
I adeded schema tests to check for not null and uniqueness. What is surprising that there are orders (with promo codes used) wihout creation timestamp which sounds weird, but perhaps they are placed through phone, if possible, so I didn't clean them. 


# Data quality
Schema tests are applied every time with every build, so we would get alerted when something unusual happens.