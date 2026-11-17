
-- =========================================================
-- OLIST E-COMMERCE ANALYTICS
-- DATA QUALITY & VALIDATION
-- Database: olist_ecommerce
--
-- RECOMMENDED CLEAN-REBUILD ORDER:
-- 1. Create all eight tables without PK/FK constraints.
-- 2. Load the source CSV files with LOAD DATA LOCAL INFILE.
-- 3. Run this script and review every validation result.
-- 4. Apply 06_database_constraints.sql only after validation.
--
-- EXECUTION-HISTORY NOTE:
-- In the initial project run, constraints were added before some validation
-- queries were executed. The zero-result NULL/duplicate/orphan checks therefore
-- describe the constrained database state, not a proven pre-constraint state.
--
-- Validation areas:
-- 0. Source-to-table row-count reconciliation
-- 1. NULL checks
-- 2. Duplicate checks
-- 3. Orphan record checks
-- 4. Product category mapping checks
-- =========================================================

USE olist_ecommerce;


-- =========================================================
-- 0. SOURCE-TO-TABLE ROW-COUNT RECONCILIATION
-- Expected counts from the supplied Olist CSV extracts.
-- Run after loading and before applying constraints.
-- =========================================================

SELECT 'customers' AS table_name, COUNT(*) AS actual_rows,
       99441 AS expected_rows,
       CASE WHEN COUNT(*) = 99441 THEN 'MATCH' ELSE 'MISMATCH' END AS status
FROM customers
UNION ALL
SELECT 'orders', COUNT(*), 99441,
       CASE WHEN COUNT(*) = 99441 THEN 'MATCH' ELSE 'MISMATCH' END
FROM orders
UNION ALL
SELECT 'order_items', COUNT(*), 112650,
       CASE WHEN COUNT(*) = 112650 THEN 'MATCH' ELSE 'MISMATCH' END
FROM order_items
UNION ALL
SELECT 'payments', COUNT(*), 103886,
       CASE WHEN COUNT(*) = 103886 THEN 'MATCH' ELSE 'MISMATCH' END
FROM payments
UNION ALL
SELECT 'products', COUNT(*), 32951,
       CASE WHEN COUNT(*) = 32951 THEN 'MATCH' ELSE 'MISMATCH' END
FROM products
UNION ALL
SELECT 'sellers', COUNT(*), 3095,
       CASE WHEN COUNT(*) = 3095 THEN 'MATCH' ELSE 'MISMATCH' END
FROM sellers
UNION ALL
SELECT 'reviews', COUNT(*), 99224,
       CASE WHEN COUNT(*) = 99224 THEN 'MATCH' ELSE 'MISMATCH' END
FROM reviews
UNION ALL
SELECT 'category_translation', COUNT(*), 71,
       CASE WHEN COUNT(*) = 71 THEN 'MATCH' ELSE 'MISMATCH' END
FROM category_translation;


-- =========================================================
-- 1. NULL CHECKS
-- Check important identifier columns for NULL values.
-- =========================================================

SELECT 'customers' AS table_name,
       'customer_id' AS column_name,
       COUNT(*) AS null_count
FROM customers
WHERE customer_id IS NULL

UNION ALL

SELECT 'orders', 'order_id', COUNT(*)
FROM orders
WHERE order_id IS NULL

UNION ALL

SELECT 'orders', 'customer_id', COUNT(*)
FROM orders
WHERE customer_id IS NULL

UNION ALL

SELECT 'order_items', 'order_id', COUNT(*)
FROM order_items
WHERE order_id IS NULL

UNION ALL

SELECT 'order_items', 'product_id', COUNT(*)
FROM order_items
WHERE product_id IS NULL

UNION ALL

SELECT 'order_items', 'seller_id', COUNT(*)
FROM order_items
WHERE seller_id IS NULL

UNION ALL

SELECT 'payments', 'order_id', COUNT(*)
FROM payments
WHERE order_id IS NULL

UNION ALL

SELECT 'products', 'product_id', COUNT(*)
FROM products
WHERE product_id IS NULL

UNION ALL

SELECT 'sellers', 'seller_id', COUNT(*)
FROM sellers
WHERE seller_id IS NULL

UNION ALL

SELECT 'reviews', 'review_id', COUNT(*)
FROM reviews
WHERE review_id IS NULL

UNION ALL

SELECT 'reviews', 'order_id', COUNT(*)
FROM reviews
WHERE order_id IS NULL

UNION ALL

SELECT 'category_translation',
       'product_category_name',
       COUNT(*)
FROM category_translation
WHERE product_category_name IS NULL;


-- =========================================================
-- 2. DUPLICATE CHECKS
-- Check duplicate primary key and composite key groups.
-- A result of zero means no duplicate groups were found.
-- =========================================================

SELECT 'customers' AS table_name,
       COUNT(*) AS duplicate_groups
FROM (
    SELECT customer_id
    FROM customers
    GROUP BY customer_id
    HAVING COUNT(*) > 1
) AS duplicates

UNION ALL

SELECT 'orders', COUNT(*)
FROM (
    SELECT order_id
    FROM orders
    GROUP BY order_id
    HAVING COUNT(*) > 1
) AS duplicates

UNION ALL

SELECT 'products', COUNT(*)
FROM (
    SELECT product_id
    FROM products
    GROUP BY product_id
    HAVING COUNT(*) > 1
) AS duplicates

UNION ALL

SELECT 'sellers', COUNT(*)
FROM (
    SELECT seller_id
    FROM sellers
    GROUP BY seller_id
    HAVING COUNT(*) > 1
) AS duplicates

UNION ALL

SELECT 'order_items', COUNT(*)
FROM (
    SELECT order_id, order_item_id
    FROM order_items
    GROUP BY order_id, order_item_id
    HAVING COUNT(*) > 1
) AS duplicates

UNION ALL

SELECT 'payments', COUNT(*)
FROM (
    SELECT order_id, payment_sequential
    FROM payments
    GROUP BY order_id, payment_sequential
    HAVING COUNT(*) > 1
) AS duplicates

UNION ALL

SELECT 'reviews', COUNT(*)
FROM (
    SELECT review_id, order_id
    FROM reviews
    GROUP BY review_id, order_id
    HAVING COUNT(*) > 1
) AS duplicates;


-- =========================================================
-- 3. ORPHAN RECORD CHECKS
-- Identify child records without matching parent records.
-- =========================================================

SELECT 'orders -> customers' AS relationship,
       COUNT(*) AS orphan_records
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT 'order_items -> orders', COUNT(*)
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT 'order_items -> products', COUNT(*)
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL

UNION ALL

SELECT 'order_items -> sellers', COUNT(*)
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL

UNION ALL

SELECT 'payments -> orders', COUNT(*)
FROM payments p
LEFT JOIN orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT 'reviews -> orders', COUNT(*)
FROM reviews r
LEFT JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;


-- =========================================================
-- 4. PRODUCT CATEGORY MAPPING CHECKS
-- Compare product categories with the translation table.
-- =========================================================

-- 4A. Identify unmatched category values.
-- Includes empty category values.

SELECT DISTINCT
    p.product_category_name
FROM products p
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND ct.product_category_name IS NULL
ORDER BY p.product_category_name;


-- 4B. Count distinct unmatched category values.
-- Empty string is counted separately from named categories.

SELECT
    COUNT(DISTINCT p.product_category_name)
        AS unmatched_category_count
FROM products p
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND ct.product_category_name IS NULL;


-- 4C. Count product records affected by category mapping issues.
-- Separates empty values and unmatched category names.

SELECT
    CASE
        WHEN p.product_category_name IS NULL THEN 'NULL'
        WHEN TRIM(p.product_category_name) = '' THEN 'EMPTY'
        ELSE p.product_category_name
    END AS category_name,
    COUNT(*) AS product_count
FROM products p
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
WHERE p.product_category_name IS NULL
   OR TRIM(p.product_category_name) = ''
   OR ct.product_category_name IS NULL
GROUP BY category_name
ORDER BY category_name;


-- 4D. Check products with NULL category values.

SELECT
    COUNT(*) AS null_category_count
FROM products
WHERE product_category_name IS NULL;
