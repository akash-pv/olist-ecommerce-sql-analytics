
-- =========================================================
-- OLIST E-COMMERCE ANALYTICS
-- Beginner SQL Queries | Q01-Q05
-- Database: olist_ecommerce
-- Revenue convention:
-- Delivered orders only; item price excludes freight.
-- =========================================================

USE olist_ecommerce;


-- Q01: List customers from Sao Paulo.
SELECT
    customer_unique_id,
    customer_city,
    customer_state
FROM customers
WHERE customer_city = 'sao paulo'
LIMIT 20;


-- Q02: Orders placed during the final 30 days of the dataset.
-- Dataset end date: 2018-10-17.
-- The final period contains a high proportion of canceled orders.
SELECT
    order_id,
    order_status,
    order_purchase_timestamp
FROM orders
WHERE order_purchase_timestamp >= DATE_SUB(
          '2018-10-17', INTERVAL 30 DAY
      )
  AND order_purchase_timestamp < '2018-10-18'
ORDER BY order_purchase_timestamp DESC;


-- Q03: Top 10 products by highest recorded item price.
-- Uses MAX(price) to identify the highest recorded price
-- for each product.
SELECT
    product_id,
    MAX(price) AS highest_price
FROM order_items
GROUP BY product_id
ORDER BY highest_price DESC
LIMIT 10;


-- Q04: Display the first 20 delivered orders.
-- Ordered by purchase timestamp for consistent results.
SELECT
    order_id,
    customer_id,
    order_purchase_timestamp
FROM orders
WHERE order_status = 'delivered'
ORDER BY order_purchase_timestamp ASC
LIMIT 20;


-- Q04 Additional Metric: Total number of delivered orders.
SELECT
    COUNT(*) AS delivered_orders
FROM orders
WHERE order_status = 'delivered';


-- Q05: Identify customers whose first recorded order
-- occurred in 2017.
-- The dataset does not contain a customer signup date.
-- Therefore, first order date is used as a proxy.
-- customer_unique_id identifies customers across orders.
SELECT
    c.customer_unique_id,
    MIN(o.order_purchase_timestamp) AS first_order
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING YEAR(MIN(o.order_purchase_timestamp)) = 2017
ORDER BY first_order
LIMIT 20;
