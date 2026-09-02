-- ==================================================
-- E-COMMERCE DATABASE ANALYSIS
-- ==================================================


-- 1. How many customers are in the database?
SELECT COUNT(*) AS total_customers
FROM customers;


-- 2. How many products are in the database?
SELECT COUNT(*) AS total_products
FROM products;


-- 3. What is the total revenue?
SELECT SUM(amount) AS total_revenue
FROM orders;


-- 4. Which product generated the highest revenue?
SELECT
    p.product_name,
    SUM(o.amount) AS total_revenue
FROM products p
INNER JOIN orders o
    ON p.product_id = o.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 1;


-- 5. How much revenue did each country generate?
SELECT
    c.country,
    SUM(o.amount) AS country_revenue
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.country
ORDER BY country_revenue DESC;


-- 6. Which product sold the highest quantity?
SELECT
    p.product_name,
    SUM(o.quantity) AS total_quantity
FROM products p
INNER JOIN orders o
    ON p.product_id = o.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 1;


-- 7. How much did each customer spend?
SELECT
    c.name,
    SUM(o.amount) AS total_spent
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC;


-- 8. What is the average order amount?
SELECT AVG(amount) AS average_order_amount
FROM orders;


-- 9. Which customers spent more than ₦500,000?
SELECT
    c.name,
    SUM(o.amount) AS total_spent
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.name
HAVING SUM(o.amount) > 500000
ORDER BY total_spent DESC;


-- 10. What are the minimum and maximum product prices?
SELECT
    MIN(price) AS cheapest_product,
    MAX(price) AS most_expensive_product
FROM products;


-- 11. How much revenue did each product category generate?
SELECT
    p.category,
    SUM(o.amount) AS category_revenue
FROM products p
INNER JOIN orders o
    ON p.product_id = o.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;


-- 12. How many orders did each customer make?
SELECT
    c.name,
    COUNT(o.order_id) AS total_orders
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_orders DESC;


-- 13. Final customer report
SELECT
    c.name,
    c.country,
    SUM(o.amount) AS total_amount,
    COUNT(o.order_id) AS total_orders
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.name, c.country
ORDER BY total_orders DESC;