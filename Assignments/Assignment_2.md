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
FROM base ```

THe repeat rate is ~ 80%

What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

- The state: my assumption is that in states where there are more land/capita people are more likely to have a house/ purchase plants
- If they used promo code or have unused promo code
- Weather: when it s nicer out theymight be more likely to spend time with gardening.

More stakeholders are coming to us for data, which is great! But we need to get some more models created before we can help. Create a marts folder, so we can organize our models, with the following subfolders for business units:

Core:
dim_product: The product dimension, containing name and id
dim_user: Containing the not sensitive information around the user and address
fct_order: The basic facts around the order
Marketing
Product
Within each marts folder, create at least 1-2 intermediate models and 1-2 dimension/fact models.


Explain the marts models you added. Why did you organize the models in the way you did?
Use the dbt docs to visualize your model DAGs to ensure the model layers make sense
Paste in an image of your DAG from the docs


(Part 2) Tests
We added some more models and transformed some data! Now we need to make sure they’re accurately reflecting the data. Add dbt tests into your dbt project on your existing models from Week 1, and new models from the section above
What assumptions are you making about each model? (i.e. why are you adding each test?)
Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
Apply these changes to your github repo
Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.