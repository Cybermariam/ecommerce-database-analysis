-- ==================================================
-- COMMON TABLE EXPRESSIONS (CTEs)
-- E-COMMERCE DATABASE
-- ==================================================


-- 1. Calculate total spending for each customer
--    using a CTE.

WITH customer_totals AS (
    SELECT
        customer_id,
        SUM(amount) AS total_spent
    FROM orders
    GROUP BY customer_id
)
SELECT *
FROM customer_totals
ORDER BY total_spent DESC;


-- 2. Find customers whose total spending
--    is greater than 500,000.

WITH customer_totals AS (
    SELECT
        customer_id,
        SUM(amount) AS total_spent
    FROM orders
    GROUP BY customer_id
)
SELECT
    c.name,
    ct.total_spent
FROM customer_totals ct
INNER JOIN customers c
    ON ct.customer_id = c.customer_id
WHERE ct.total_spent > 500000
ORDER BY ct.total_spent DESC;


-- 3. Calculate the average customer total
--    and find customers above that average.

WITH customer_totals AS (
    SELECT
        customer_id,
        SUM(amount) AS total_spent
    FROM orders
    GROUP BY customer_id
)
SELECT
    c.name,
    ct.total_spent
FROM customer_totals ct
INNER JOIN customers c
    ON ct.customer_id = c.customer_id
WHERE ct.total_spent > (
    SELECT AVG(total_spent)
    FROM customer_totals
)
ORDER BY ct.total_spent DESC;


-- 4. Multiple CTEs:
--    Calculate customer totals and then
--    calculate the average customer total.

WITH customer_totals AS (
    SELECT
        customer_id,
        SUM(amount) AS total_spent
    FROM orders
    GROUP BY customer_id
),
average_customer_total AS (
    SELECT AVG(total_spent) AS average_spent
    FROM customer_totals
)
SELECT
    c.name,
    ct.total_spent
FROM customer_totals ct
INNER JOIN customers c
    ON ct.customer_id = c.customer_id
CROSS JOIN average_customer_total a
WHERE ct.total_spent > a.average_spent
ORDER BY ct.total_spent DESC;


-- 5. Country revenue using a CTE.

WITH country_sales AS (
    SELECT
        c.country,
        SUM(o.amount) AS total_revenue
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.country
)
SELECT
    country,
    total_revenue
FROM country_sales
ORDER BY total_revenue DESC;