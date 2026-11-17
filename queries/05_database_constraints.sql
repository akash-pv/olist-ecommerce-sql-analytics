
-- ============================================================
-- OLIST E-COMMERCE SQL ANALYTICS
-- File: 05_database_constraints.sql
-- Database: olist_ecommerce
-- Purpose: Define Primary Keys and Foreign Keys
-- MySQL 8.0
-- ============================================================

USE olist_ecommerce;

-- 1. CUSTOMERS
ALTER TABLE customers
MODIFY customer_id VARCHAR(50) NOT NULL,
ADD PRIMARY KEY (customer_id);

-- 2. ORDERS
ALTER TABLE orders
MODIFY order_id VARCHAR(50) NOT NULL,
ADD PRIMARY KEY (order_id);

ALTER TABLE orders
MODIFY customer_id VARCHAR(50) NOT NULL,
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

-- 3. PRODUCTS
ALTER TABLE products
MODIFY product_id VARCHAR(50) NOT NULL,
ADD PRIMARY KEY (product_id);

-- 4. SELLERS
ALTER TABLE sellers
MODIFY seller_id VARCHAR(50) NOT NULL,
ADD PRIMARY KEY (seller_id);

-- 5. ORDER ITEMS
ALTER TABLE order_items
MODIFY order_id VARCHAR(50) NOT NULL,
MODIFY order_item_id INT NOT NULL,
ADD PRIMARY KEY (order_id, order_item_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_orders
FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_products
FOREIGN KEY (product_id) REFERENCES products(product_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_sellers
FOREIGN KEY (seller_id) REFERENCES sellers(seller_id);

-- 6. PAYMENTS
ALTER TABLE payments
MODIFY order_id VARCHAR(50) NOT NULL,
MODIFY payment_sequential INT NOT NULL,
ADD PRIMARY KEY (order_id, payment_sequential);

ALTER TABLE payments
ADD CONSTRAINT fk_payments_orders
FOREIGN KEY (order_id) REFERENCES orders(order_id);

-- 7. REVIEWS
ALTER TABLE reviews
MODIFY review_id VARCHAR(50) NOT NULL,
MODIFY order_id VARCHAR(50) NOT NULL,
ADD PRIMARY KEY (review_id, order_id);

ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_orders
FOREIGN KEY (order_id) REFERENCES orders(order_id);

-- 8. CATEGORY TRANSLATION
ALTER TABLE category_translation
MODIFY product_category_name VARCHAR(100) NOT NULL,
ADD PRIMARY KEY (product_category_name);

-- NOTE:
-- products.product_category_name and
-- category_translation.product_category_name
-- have a logical relationship, but no FK constraint.
-- 13 product records have unmatched categories.

-- FINAL VERIFICATION
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'olist_ecommerce'
  AND (
      CONSTRAINT_NAME = 'PRIMARY'
      OR REFERENCED_TABLE_NAME IS NOT NULL
  )
ORDER BY TABLE_NAME, CONSTRAINT_NAME, ORDINAL_POSITION;
