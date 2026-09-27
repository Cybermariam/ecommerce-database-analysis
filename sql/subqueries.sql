-- ==================================================
-- SUBQUERY PRACTICE
-- E-COMMERCE DATABASE
-- ==================================================


-- 1. Find orders with an amount greater than
--    the average individual order amount.

SELECT
    order_id,
    customer_id,
    amount
FROM orders
WHERE amount > (
    SELECT AVG(amount)
    FROM orders
)
ORDER BY amount DESC;


-- 2. Find customers whose total spending is
--    greater than the average customer total.

SELECT
    c.name,
    SUM(o.amount) AS total_spent
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.name
HAVING SUM(o.amount) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT
            customer_id,
            SUM(amount) AS customer_total
        FROM orders
        GROUP BY customer_id
    ) AS customer_totals
)
ORDER BY total_spent DESC;


-- 3. Subquery in FROM:
--    Calculate each customer's total spending
--    using a derived table.

SELECT
    customer_id,
    total_spent
FROM (
    SELECT
        customer_id,
        SUM(amount) AS total_spent
    FROM orders
    GROUP BY customer_id
) AS customer_totals
ORDER BY total_spent DESC;