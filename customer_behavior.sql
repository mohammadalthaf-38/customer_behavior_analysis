-- Revenue by Gender
SELECT
    gender,
    SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY gender
ORDER BY total_revenue DESC;

--Customers Who Used Discounts but Spent Above Average
SELECT
    customer_id,
    purchase_amount,
    discount_applied
FROM customer
WHERE discount_applied = 'Yes'
AND purchase_amount >
(
    SELECT AVG(purchase_amount)
    FROM customer
);

--Top 5 Products by Average Rating
SELECT
    item_purchased,
    ROUND(AVG(review_rating)::numeric, 2) AS avg_rating
FROM customer
GROUP BY item_purchased
ORDER BY avg_rating DESC
LIMIT 5;
-- Compare Shipping Types
SELECT
    shipping_type,
    ROUND(AVG(purchase_amount)::numeric, 2) AS avg_purchase
FROM customer
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY shipping_type;

--subscription analysis
SELECT
    subscription_status,
    COUNT(customer_id) AS customers,
    ROUND(AVG(purchase_amount)::numeric, 2) AS avg_purchase,
    SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY subscription_status;

-- Products With Highest Discount Dependency
SELECT
    item_purchased,
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN discount_applied = 'Yes'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;

-- Top 3 Products in Each Category
WITH product_sales AS (
    SELECT
        category,
        item_purchased,
        COUNT(*) AS purchase_count
    FROM customer
    GROUP BY category, item_purchased
),

ranked_products AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY purchase_count DESC
        ) AS rank
    FROM product_sales
)

SELECT *
FROM ranked_products
WHERE rank <= 3;

-- Revenue by Age Group
SELECT
    age_group,
    SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;




