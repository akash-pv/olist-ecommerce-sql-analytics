-- OLIST E-COMMERCE ANALYTICS
-- Beginner SQL queries | Q01-Q05
-- Database: olist_ecommerce
-- Revenue convention for this project: delivered orders only; item price excludes freight.

USE olist_ecommerce;

-- Q01: List customers from a specific city (Sao Paulo).
SELECT
    customer_unique_id,
    customer_city,
    customer_state
FROM customers
WHERE customer_city = 'sao paulo'
LIMIT 20;


-- Q02: Orders placed in the last 30 days of the dataset.
-- Dataset ends on 2018-10-17. The result is expected to contain mostly/only
-- canceled orders because the dataset's final period has limited activity.
SELECT
    order_id,
    order_status,
    order_purchase_timestamp
FROM orders
WHERE order_purchase_timestamp >= DATE_SUB('2018-10-17', INTERVAL 30 DAY)
  AND order_purchase_timestamp < '2018-10-18'
ORDER BY order_purchase_timestamp DESC;


-- Q03: The 10 most expensive products (highest recorded item price per product).
SELECT
    product_id,
    MAX(price) AS highest_price
FROM order_items
GROUP BY product_id
ORDER BY highest_price DESC
LIMIT 10;


-- Q04: Show the first 20 delivered orders.
SELECT
    order_id,
    customer_id,
    order_purchase_timestamp
FROM orders
WHERE order_status = 'delivered'
LIMIT 20;

-- Q04 additional metric: total number of delivered orders.
SELECT
    COUNT(*) AS delivered_orders
FROM orders
WHERE order_status = 'delivered';


-- Q05: Customers whose first recorded order was in 2017.
-- The dataset does not contain a customer signup date, so first order date
-- is used as a proxy. customer_unique_id identifies a customer across orders.
SELECT
    c.customer_unique_id,
    MIN(o.order_purchase_timestamp) AS first_order
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING YEAR(MIN(o.order_purchase_timestamp)) = 2017
LIMIT 20;
