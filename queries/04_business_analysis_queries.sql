-- OLIST E-COMMERCE ANALYTICS
-- Additional business analysis queries | Q17-Q21
-- Database: olist_ecommerce
-- Revenue convention: delivered orders only; item price excludes freight.

USE olist_ecommerce;


-- Q17: Customer cities generating the highest delivered item sales.
SELECT
    c.customer_city,
    SUM(oi.price) AS total_price
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_city
ORDER BY total_price DESC
LIMIT 10;


-- Q18: Investigate orders that have no matching order_items records.
-- This helps explain why an INNER JOIN can exclude some orders.
SELECT
    o.order_status,
    COUNT(*) AS orders_without_items
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL
GROUP BY o.order_status
ORDER BY orders_without_items DESC;


-- Q19: Month-over-month revenue growth using LAG().
-- Requires the monthly_sales_summary view created in Q15.
SELECT
    order_month,
    revenue,
    LAG(revenue) OVER (ORDER BY order_month) AS previous_month_revenue,
    ROUND(
        (
            revenue - LAG(revenue) OVER (ORDER BY order_month)
        ) / NULLIF(LAG(revenue) OVER (ORDER BY order_month), 0) * 100,
        1
    ) AS growth_pct
FROM monthly_sales_summary
ORDER BY order_month;


-- Q20: Product categories with the lowest average review scores.
-- Only delivered orders are included; each review is counted once per category.
-- A review may appear in more than one category if its order contains products
-- from multiple categories.
SELECT
    category,
    ROUND(AVG(review_score), 2) AS avg_review_score,
    COUNT(*) AS reviews
FROM (
    SELECT DISTINCT
        r.review_id,
        r.review_score,
        COALESCE(
            t.product_category_name_english,
            NULLIF(p.product_category_name, ''),
            'unknown'
        ) AS category
    FROM orders o
    JOIN reviews r
        ON o.order_id = r.order_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    LEFT JOIN category_translation t
        ON p.product_category_name = t.product_category_name
    WHERE o.order_status = 'delivered'
) AS category_reviews
GROUP BY category
HAVING COUNT(*) >= 100
ORDER BY avg_review_score ASC
LIMIT 10;


-- Q21: Delivered orders arriving later than the estimated delivery date.
-- Rows with missing actual or estimated delivery dates are excluded.
SELECT
    COUNT(*) AS delivered_orders,
    SUM(
        order_delivered_customer_date > order_estimated_delivery_date
    ) AS late_orders,
    ROUND(
        100 * SUM(
            order_delivered_customer_date > order_estimated_delivery_date
        ) / COUNT(*),
        1
    ) AS late_pct,
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ),
        1
    ) AS avg_delivery_days
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;
