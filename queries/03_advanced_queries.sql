-- OLIST E-COMMERCE ANALYTICS
-- Advanced SQL queries | Q12-Q16
-- Database: olist_ecommerce
-- Revenue convention: delivered orders only; item price excludes freight.

USE olist_ecommerce;


-- Q12: Rank products by revenue within each category (top 3 per category).
-- No global LIMIT is used, so all categories can return their top-ranked products.
WITH product_revenue AS (
    SELECT
        COALESCE(
            t.product_category_name_english,
            NULLIF(p.product_category_name, ''),
            'unknown'
        ) AS category,
        oi.product_id,
        SUM(oi.price) AS revenue
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    LEFT JOIN category_translation t
        ON p.product_category_name = t.product_category_name
    WHERE o.order_status = 'delivered'
    GROUP BY category, oi.product_id
),
ranked AS (
    SELECT
        category,
        product_id,
        revenue,
        RANK() OVER (
            PARTITION BY category
            ORDER BY revenue DESC
        ) AS rnk
    FROM product_revenue
)
SELECT
    category,
    product_id,
    revenue,
    rnk
FROM ranked
WHERE rnk <= 3
ORDER BY category, rnk, revenue DESC;


-- Q13: Customers whose delivered item spend is above the average customer spend.
SELECT
    c.customer_unique_id,
    SUM(oi.price) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
HAVING SUM(oi.price) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT
            SUM(oi2.price) AS customer_total
        FROM customers c2
        JOIN orders o2
            ON c2.customer_id = o2.customer_id
        JOIN order_items oi2
            ON o2.order_id = oi2.order_id
        WHERE o2.order_status = 'delivered'
        GROUP BY c2.customer_unique_id
    ) AS customer_totals
)
ORDER BY total_spent DESC
LIMIT 20;


-- Q14: Repeat customers with more than 2 orders.
-- customer_unique_id is used to identify the same customer across order-specific customer_id values.
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS orders_placed
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) > 2
ORDER BY orders_placed DESC;

-- Q14 validation: the original guide's threshold of more than 20 orders.
-- This may return no rows in this dataset.
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS orders_placed
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) > 20;


-- Q15: Create a reusable monthly sales summary view.
-- Run this CREATE VIEW statement once, then run the SELECT below it.
CREATE OR REPLACE VIEW monthly_sales_summary AS
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(DISTINCT o.order_id) AS orders,
    SUM(oi.price) AS revenue,
    SUM(oi.freight_value) AS freight,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m');

-- Q15: Query the view.
SELECT *
FROM monthly_sales_summary
ORDER BY order_month;


-- Q16: Create a stored procedure for one customer's order history.
-- Execute the complete DROP/DELIMITER/CREATE block together in MySQL Workbench.
DROP PROCEDURE IF EXISTS get_customer_history;

DELIMITER //

CREATE PROCEDURE get_customer_history(IN p_customer_unique_id VARCHAR(50))
BEGIN
    SELECT
        o.order_id,
        o.order_status,
        o.order_purchase_timestamp,
        COUNT(oi.order_item_id) AS items,
        COALESCE(SUM(oi.price), 0) AS order_value
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE c.customer_unique_id = p_customer_unique_id
    GROUP BY
        o.order_id,
        o.order_status,
        o.order_purchase_timestamp
    ORDER BY o.order_purchase_timestamp;
END //

DELIMITER ;

-- Q16: After creating the procedure, replace the placeholder below with
-- a real customer_unique_id from the Q14 result, then execute the CALL.
-- CALL get_customer_history('paste_a_customer_unique_id_here');
