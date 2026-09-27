-- ==================================================
-- WINDOW FUNCTIONS
-- E-COMMERCE DATABASE
-- ==================================================


-- 1. ROW_NUMBER()
--    Assign a unique number to each order
--    based on amount, highest first.

SELECT
    order_id,
    customer_id,
    amount,
    ROW_NUMBER() OVER (
        ORDER BY amount DESC
    ) AS row_num
FROM orders;


-- 2. ROW_NUMBER() with PARTITION BY
--    Rank orders separately for each customer.

SELECT
    customer_id,
    order_id,
    amount,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY amount DESC
    ) AS customer_order_rank
FROM orders;


-- 3. Find each customer's latest order
--    using ROW_NUMBER() and a CTE.

WITH ranked_orders AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        amount,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date DESC
        ) AS row_num
    FROM orders
)
SELECT
    customer_id,
    order_id,
    order_date,
    amount
FROM ranked_orders
WHERE row_num = 1;


-- 4. RANK()
--    Rank orders by amount.
--    Ties receive the same rank.

SELECT
    order_id,
    amount,
    RANK() OVER (
        ORDER BY amount DESC
    ) AS amount_rank
FROM orders;


-- 5. DENSE_RANK()
--    Rank orders by amount without gaps
--    after tied values.

SELECT
    order_id,
    amount,
    DENSE_RANK() OVER (
        ORDER BY amount DESC
    ) AS amount_rank
FROM orders;


-- 6. RANK() with PARTITION BY
--    Rank each customer's orders separately.

SELECT
    customer_id,
    order_id,
    amount,
    RANK() OVER (
        PARTITION BY customer_id
        ORDER BY amount DESC
    ) AS customer_rank
FROM orders;


-- 7. LAG()
--    Compare each order with the previous order
--    for the same customer.

SELECT
    customer_id,
    order_id,
    order_date,
    amount,
    LAG(amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS previous_amount
FROM orders;


-- 8. Calculate the change from the previous order.

WITH order_analysis AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        amount,
        LAG(amount) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS previous_amount
    FROM orders
)
SELECT
    customer_id,
    order_id,
    order_date,
    amount,
    previous_amount,
    amount - previous_amount AS amount_change
FROM order_analysis;


-- 9. LEAD()
--    Look at the next order for each customer.

SELECT
    customer_id,
    order_id,
    order_date,
    amount,
    LEAD(amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS next_amount
FROM orders;


-- 10. SUM() OVER
--     Calculate each customer's total spending
--     while keeping individual order rows.

SELECT
    customer_id,
    order_id,
    amount,
    SUM(amount) OVER (
        PARTITION BY customer_id
    ) AS customer_total
FROM orders;


-- 11. Running total
--     Calculate cumulative spending for each customer.

SELECT
    customer_id,
    order_id,
    order_date,
    amount,
    SUM(amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS running_total
FROM orders;


-- 12. AVG() OVER
--     Show the average order amount alongside
--     each individual order.

SELECT
    order_id,
    customer_id,
    amount,
    AVG(amount) OVER () AS average_order_amount
FROM orders;


-- 13. COUNT() OVER
--     Show the number of orders for each customer
--     while keeping individual order rows.

SELECT
    customer_id,
    order_id,
    amount,
    COUNT(*) OVER (
        PARTITION BY customer_id
    ) AS customer_order_count
FROM orders;


-- 14. Moving average
--     Calculate the average of the current order
--     and the previous two orders.

SELECT
    order_id,
    order_date,
    amount,
    AVG(amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_average
FROM orders;


-- 15. Final window-function analysis
--     Compare each order with the customer's
--     previous order and calculate the change.

WITH order_analysis AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        amount,
        LAG(amount) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS previous_amount
    FROM orders
)
SELECT
    customer_id,
    order_id,
    order_date,
    amount,
./    amount - previous_amount AS amount_change
FROM order_analysis
ORDER BY customer_id, order_date;