-- Counting rows for each table

SELECT 'customers' AS tbl, COUNT(*) FROM customers
UNION ALL SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL SELECT 'product_category_name_translation', COUNT(*) FROM product_category_name_translation;


-- Checking for NULL values

SELECT 'customers' AS tbl, 'customer_id' AS col, COUNT(*) - COUNT(customer_id) AS null_count FROM customers
UNION ALL SELECT 'customers', 'customer_unique_id', COUNT(*) - COUNT(customer_unique_id) FROM customers
UNION ALL SELECT 'customers', 'customer_zip_code_prefix', COUNT(*) - COUNT(customer_zip_code_prefix) FROM customers
UNION ALL SELECT 'customers', 'customer_city', COUNT(*) - COUNT(customer_city) FROM customers
UNION ALL SELECT 'customers', 'customer_state', COUNT(*) - COUNT(customer_state) FROM customers

UNION ALL SELECT 'geolocation', 'geolocation_zip_code_prefix', COUNT(*) - COUNT(geolocation_zip_code_prefix) FROM geolocation
UNION ALL SELECT 'geolocation', 'geolocation_lat', COUNT(*) - COUNT(geolocation_lat) FROM geolocation
UNION ALL SELECT 'geolocation', 'geolocation_lng', COUNT(*) - COUNT(geolocation_lng) FROM geolocation
UNION ALL SELECT 'geolocation', 'geolocation_city', COUNT(*) - COUNT(geolocation_city) FROM geolocation
UNION ALL SELECT 'geolocation', 'geolocation_state', COUNT(*) - COUNT(geolocation_state) FROM geolocation

UNION ALL SELECT 'order_items', 'order_id', COUNT(*) - COUNT(order_id) FROM order_items
UNION ALL SELECT 'order_items', 'order_item_id', COUNT(*) - COUNT (order_item_id) FROM order_items
UNION ALL SELECT 'order_items', 'product_id', COUNT(*) - COUNT(product_id) FROM order_items
UNION ALL SELECT 'order_items', 'seller_id', COUNT(*) - COUNT(seller_id) FROM order_items
UNION ALL SELECT 'order_items', 'shipping_limit_date', COUNT (*) - COUNT(shipping_limit_date) FROM order_items
UNION ALL SELECT 'order_items', 'price', COUNT(*) - COUNT(price) FROM order_items
UNION ALL SELECT 'order_items', 'freight_value', COUNT(*) - COUNT(freight_value) FROM order_items

UNION ALL SELECT 'order_payments', 'order_id', COUNT(*) - COUNT(order_id) FROM order_payments
UNION ALL SELECT 'order_payments', 'payment_sequential', COUNT(*) - COUNT(payment_sequential) FROM order_payments
UNION ALL SELECT 'order_payments', 'payment_type', COUNT(*) - COUNT(payment_type) FROM order_payments
UNION ALL SELECT 'order_payments', 'payment_installments', COUNT(*) - COUNT(payment_installments) FROM order_payments
UNION ALL SELECT 'order_payments', 'payment_value', COUNT(*) - COUNT(payment_value) FROM order_payments

UNION ALL SELECT 'order_reviews', 'review_id', COUNT(*) - COUNT(review_id) FROM order_reviews
UNION ALL SELECT 'order_reviews', 'order_id', COUNT(*) - COUNT(order_id) FROM order_reviews
UNION ALL SELECT 'order_reviews', 'review_score', COUNT(*) - COUNT(review_score) FROM order_reviews
UNION ALL SELECT 'order_reviews', 'review_comment_title', COUNT(*) - COUNT(review_comment_title) FROM order_reviews
UNION ALL SELECT 'order_reviews', 'review_comment_message', COUNT(*) - COUNT(review_comment_message) FROM order_reviews
UNION ALL SELECT 'order_reviews', 'review_creation_date', COUNT(*) - COUNT(review_creation_date) FROM order_reviews
UNION ALL SELECT 'order_reviews', 'review_answer_timestamp', COUNT(*) - COUNT(review_answer_timestamp) FROM order_reviews

UNION ALL SELECT 'orders', 'order_id', COUNT(*) - COUNT(order_id) FROM orders
UNION ALL SELECT 'orders', 'customer_id', COUNT(*) - COUNT(customer_id) FROM orders
UNION ALL SELECT 'orders', 'order_status', COUNT(*) - COUNT(order_status) FROM orders
UNION ALL SELECT 'orders', 'order_purchase_timestamp', COUNT(*) - COUNT(order_purchase_timestamp) FROM orders
UNION ALL SELECT 'orders', 'order_approved_at', COUNT(*) - COUNT(order_approved_at) FROM orders
UNION ALL SELECT 'orders', 'order_delivered_carrier_date', COUNT(*) - COUNT(order_delivered_carrier_date) FROM orders
UNION ALL SELECT 'orders', 'order_delivered_customer_date', COUNT(*) - COUNT(order_delivered_customer_date) FROM orders
UNION ALL SELECT 'orders', 'order_estimated_delivery_date', COUNT(*) - COUNT(order_estimated_delivery_date) FROM orders

UNION ALL SELECT 'products', 'product_id', COUNT(*) - COUNT(product_id) FROM products
UNION ALL SELECT 'products', 'product_category_name', COUNT(*) - COUNT(product_category_name) FROM products
UNION ALL SELECT 'products', 'product_name_lenght', COUNT(*) - COUNT(product_name_lenght) FROM products
UNION ALL SELECT 'products', 'product_description_lenght', COUNT(*) - COUNT(product_description_lenght) FROM products
UNION ALL SELECT 'products', 'product_photos_qty', COUNT(*) - COUNT(product_photos_qty) FROM products
UNION ALL SELECT 'products', 'product_weight_g', COUNT(*) - COUNT(product_weight_g) FROM products
UNION ALL SELECT 'products', 'product_length_cm', COUNT(*) - COUNT(product_length_cm) FROM products
UNION ALL SELECT 'products', 'product_height_cm', COUNT(*) - COUNT(product_height_cm) FROM products
UNION ALL SELECT 'products', 'product_width_cm', COUNT(*) - COUNT(product_width_cm) FROM products

UNION ALL SELECT 'sellers', 'seller_id', COUNT(*) - COUNT(seller_id) FROM sellers
UNION ALL SELECT 'sellers', 'seller_zip_code_prefix', COUNT(*) - COUNT(seller_zip_code_prefix) FROM sellers
UNION ALL SELECT 'sellers', 'seller_city', COUNT(*) - COUNT(seller_city) FROM sellers
UNION ALL SELECT 'sellers', 'seller_state', COUNT(*) - COUNT(seller_state) FROM sellers

UNION ALL SELECT 'product_category_name_translation', 'product_category_name', COUNT(*) - COUNT(product_category_name) FROM product_category_name_translation
UNION ALL SELECT 'product_category_name_translation', 'product_category_name_english', COUNT(*) - COUNT(product_category_name_english) FROM product_category_name_translation

ORDER BY null_count DESC;


-- Check for Duplicate IDs

SELECT 'customers' AS tbl, 'customer_id' AS col, COUNT(*) AS dup_groups
FROM (SELECT customer_id FROM customers GROUP BY customer_id HAVING COUNT(*) > 1) AS x

UNION ALL SELECT 'orders', 'order_id', COUNT(*)
FROM (SELECT order_id FROM orders GROUP BY order_id HAVING COUNT(*) > 1) AS x

UNION ALL SELECT 'products', 'product_id', COUNT(*)
FROM (SELECT product_id FROM products GROUP BY product_id HAVING COUNT(*) > 1) AS x

UNION ALL SELECT 'sellers', 'seller_id', COUNT(*)
FROM (SELECT seller_id FROM sellers GROUP BY seller_id HAVING COUNT(*) > 1) AS x

UNION ALL SELECT 'order_reviews', 'review_id', COUNT(*)
FROM (SELECT review_id FROM order_reviews GROUP BY review_id HAVING COUNT(*) > 1) AS x

UNION ALL SELECT 'product_category_name_translation', 'product_category_name', COUNT(*)
FROM (SELECT product_category_name FROM product_category_name_translation GROUP BY product_category_name HAVING COUNT(*) > 1) AS x

UNION ALL SELECT 'product_category_name_translation', 'product_category_name_english', COUNT(*)
FROM (SELECT product_category_name_english FROM product_category_name_translation GROUP BY product_category_name_english HAVING COUNT(*) > 1) AS x

UNION ALL SELECT 'order_items', 'order_id+order_item_id', COUNT(*)
FROM (SELECT order_id, order_item_id FROM order_items GROUP BY order_id, order_item_id HAVING COUNT(*) > 1) AS x

UNION ALL SELECT 'order_payments', 'order_id+payment_sequential', COUNT(*)
FROM (SELECT order_id, payment_sequential FROM order_payments GROUP BY order_id, payment_sequential HAVING COUNT(*) > 1) AS x

ORDER BY dup_groups DESC;


-- Checking for Potential Primary key candidates via checking NULL values and Duplicate IDs simultaneously

SELECT 'customers.customer_id' AS candidate,
       (SELECT COUNT(*) FROM customers WHERE customer_id IS NULL) AS nulls,
       (SELECT COUNT(*) FROM (SELECT customer_id FROM customers GROUP BY customer_id HAVING COUNT(*)>1) x) AS dup_groups

UNION ALL SELECT 'orders.order_id',
       (SELECT COUNT(*) FROM orders WHERE order_id IS NULL),
       (SELECT COUNT(*) FROM (SELECT order_id FROM orders GROUP BY order_id HAVING COUNT(*)>1) x)

UNION ALL SELECT 'products.product_id',
       (SELECT COUNT(*) FROM products WHERE product_id IS NULL),
       (SELECT COUNT(*) FROM (SELECT product_id FROM products GROUP BY product_id HAVING COUNT(*)>1) x)

UNION ALL SELECT 'sellers.seller_id',
       (SELECT COUNT(*) FROM sellers WHERE seller_id IS NULL),
       (SELECT COUNT(*) FROM (SELECT seller_id FROM sellers GROUP BY seller_id HAVING COUNT(*)>1) x)

UNION ALL SELECT 'order_reviews.review_id',
       (SELECT COUNT(*) FROM order_reviews WHERE review_id IS NULL),
       (SELECT COUNT(*) FROM (SELECT review_id FROM order_reviews GROUP BY review_id HAVING COUNT(*)>1) x)

UNION ALL SELECT 'product_cateory_name_translation.product_category_name',
       (SELECT COUNT(*) FROM product_category_name_translation WHERE product_category_name IS NULL),
       (SELECT COUNT(*) FROM(SELECT product_category_name FROM product_category_name_translation GROUP BY product_category_name HAVING COUNT (*) > 1) x )

-- composite keys:PK checks for order_items and order_payments

UNION ALL SELECT 'order_items.(order_id+order_item_id)',
       (SELECT COUNT(*) FROM order_items WHERE order_id IS NULL OR order_item_id IS NULL),
       (SELECT COUNT(*) FROM (SELECT order_id, order_item_id FROM order_items GROUP BY order_id, order_item_id HAVING COUNT(*)>1) x)

UNION ALL SELECT 'order_payments.(order_id+payment_sequential)',
       (SELECT COUNT(*) FROM order_payments WHERE order_id IS NULL OR payment_sequential IS NULL),
       (SELECT COUNT(*) FROM (SELECT order_id, payment_sequential FROM order_payments GROUP BY order_id, payment_sequential HAVING COUNT(*)>1) x)

ORDER BY nulls DESC, dup_groups DESC;


-- Basic data consistency checks
-- 01. Relationship checks (referential integrity)

SELECT 'orders.customer_id -> customers' AS relationship, COUNT(*) AS orphaned_rows
FROM orders o
WHERE NOT EXISTS (SELECT 1 FROM customers c WHERE c.customer_id = o.customer_id)

UNION ALL SELECT 'order_items.order_id -> orders', COUNT(*)
FROM order_items oi
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.order_id = oi.order_id)

UNION ALL SELECT 'order_items.product_id -> products', COUNT(*)
FROM order_items oi
WHERE NOT EXISTS (SELECT 1 FROM products p WHERE p.product_id = oi.product_id)

UNION ALL SELECT 'order_items.seller_id -> sellers', COUNT(*)
FROM order_items oi
WHERE NOT EXISTS (SELECT 1 FROM sellers s WHERE s.seller_id = oi.seller_id)

UNION ALL SELECT 'order_payments.order_id -> orders', COUNT(*)
FROM order_payments op
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.order_id = op.order_id)

UNION ALL SELECT 'order_reviews.order_id -> orders', COUNT(*)
FROM order_reviews r
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.order_id = r.order_id)

UNION ALL SELECT 'products.product_category_name -> translation', COUNT(*)
FROM products p
WHERE p.product_category_name IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM product_category_name_translation t WHERE t.product_category_name = p.product_category_name)

UNION ALL SELECT 'order_payments.order_id -> order_items', COUNT(*)
FROM order_payments op
WHERE NOT EXISTS (SELECT 1 FROM order_items oi WHERE oi.order_id = op.order_id)

UNION ALL SELECT 'order_items.order_id -> order_payments', COUNT(*)
FROM order_items oi
WHERE NOT EXISTS (SELECT 1 FROM order_payments op WHERE op.order_id = oi.order_id)

ORDER BY orphaned_rows DESC;


-- Consistency checks: comparing columns within the same row

SELECT 'approved_before_purchase' AS check_name, COUNT(*) AS violations
FROM orders
WHERE order_approved_at < order_purchase_timestamp

UNION ALL SELECT 'shipped_before_approved', COUNT(*)
FROM orders
WHERE order_delivered_carrier_date < order_approved_at

UNION ALL SELECT 'delivered_before_shipped', COUNT(*)
FROM orders
WHERE order_delivered_customer_date < order_delivered_carrier_date

ORDER BY violations DESC;

-- Status/date consistency: a 'delivered' order should have a delivery date

SELECT 'delivered_status_but_no_delivery_date' AS check_name, COUNT(*) AS violations
FROM orders
WHERE order_status = 'delivered' AND order_delivered_customer_date IS NULL

UNION ALL SELECT 'review_answered_before_created', COUNT(*)
FROM order_reviews
WHERE review_answer_timestamp < review_creation_date

ORDER BY violations DESC;

