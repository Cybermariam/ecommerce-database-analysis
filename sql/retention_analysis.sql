-- ==================================================
-- CUSTOMER RETENTION / REPEAT-PURCHASE ANALYSIS
-- E-COMMERCE DATABASE
-- ==================================================


-- BUSINESS QUESTION:
-- Are customers coming back after their first purchase?
--
-- For this dataset, we measure repeat-purchase retention:
-- whether a customer made at least one purchase after
-- their first purchase.


-- 1. Identify each customer's first order.

WITH first_orders AS (
    SELECT *
    FROM (
        SELECT
            customer_id,
            order_id,
            order_date,
            ROW_NUMBER() OVER (
                PARTITION BY customer_id
                ORDER BY order_date
            ) AS row_num
        FROM orders
    ) x
    WHERE row_num = 1
)
SELECT *
FROM first_orders
ORDER BY customer_id;


-- 2. Identify customers who made a purchase
--    after their first order.

WITH first_orders AS (
    SELECT *
    FROM (
        SELECT
            customer_id,
            order_id,
            order_date,
            ROW_NUMBER() OVER (
                PARTITION BY customer_id
                ORDER BY order_date
            ) AS row_num
        FROM orders
    ) x
    WHERE row_num = 1
)
SELECT
    f.customer_id,
    f.order_date AS first_order_date,
    o.order_id AS return_order_id,
    o.order_date AS return_order_date
FROM first_orders f
INNER JOIN orders o
    ON f.customer_id = o.customer_id
    AND o.order_date > f.order_date
ORDER BY f.customer_id;


-- 3. Calculate the number of days between
--    the first order and each return order.
--    Also classify customers as returned or not returned.

WITH first_orders AS (
    SELECT *
    FROM (
        SELECT
            customer_id,
            order_id,
            order_date,
            ROW_NUMBER() OVER (
                PARTITION BY customer_id
                ORDER BY order_date
            ) AS row_num
        FROM orders
    ) x
    WHERE row_num = 1
)
SELECT
    f.customer_id,
    f.order_date AS first_order_date,
    o.order_id AS return_order_id,
    o.order_date AS return_order_date,
    o.order_date - f.order_date AS days_to_return,
    CASE
        WHEN o.order_id IS NULL THEN 'No'
        ELSE 'Yes'
    END AS returned
FROM first_orders f
LEFT JOIN orders o
    ON f.customer_id = o.customer_id
    AND o.order_date > f.order_date
ORDER BY f.customer_id;


-- 4. Calculate the overall repeat-purchase rate.

WITH first_orders AS (
    SELECT *
    FROM (
        SELECT
            customer_id,
            order_id,
            order_date,
            ROW_NUMBER() OVER (
                PARTITION BY customer_id
                ORDER BY order_date
            ) AS row_num
        FROM orders
    ) x
    WHERE row_num = 1
),

returning_customers AS (
    SELECT COUNT(DISTINCT o.customer_id) AS returning_customers
    FROM first_orders f
    JOIN orders o
        ON o.customer_id = f.customer_id
    WHERE o.order_date > f.order_date
)

SELECT
    returning_customers,
    (SELECT COUNT(DISTINCT customer_id) FROM orders)
        AS total_customers,
    returning_customers * 100.0 /
    (SELECT COUNT(DISTINCT customer_id) FROM orders)
        AS repeat_purchase_rate
FROM returning_customers;


-- ==================================================
-- FINAL RESULT FROM CURRENT DATASET
--
-- Returning customers: 4
-- Total customers: 8
-- Repeat-purchase rate: 50%
--
-- Note:
-- This dataset covers August 1-12, 2026.
-- Therefore, this analysis measures repeat purchases
-- within the available data period rather than a full
-- monthly cohort-retention analysis.
-- ==================================================