-- Views built specifically for Power BI to connect to.
-- Each one reuses the exact join/grouping logic already
-- verified in the sql_queries/ analysis files — nothing here
-- is new analysis, just repackaged as a permanent, queryable
-- object so Power BI's "Get Data" can actually see it.

-- bi_monthly_revenue: Revenue trend (Page 1)
-- Same logic as 02_revenue_analysis.sql Step 2
CREATE VIEW bi_monthly_revenue AS
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    SUM(op.payment_value) AS monthly_revenue,
    COUNT(DISTINCT o.order_id) AS order_count
FROM valid_orders o
JOIN order_payments op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp);

-- bi_category_summary: Category analysis (Page 2) + satisfaction (Page 4 scatter)
-- Combines 03_product_analysis.sql (revenue/orders) with
-- 08_customer_satisfaction.sql Step 3 (avg review score) at the same grain
CREATE VIEW bi_category_summary AS
SELECT
    COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
    SUM(oi.price) AS revenue,
    COUNT(oi.order_item_id) AS items_sold,
    COUNT(DISTINCT oi.order_id) AS distinct_orders,
    ROUND(SUM(oi.price) / COUNT(DISTINCT oi.order_id), 2) AS avg_order_value,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM valid_orders o
JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
LEFT JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY COALESCE(t.product_category_name_english, p.product_category_name, 'unknown');


 
-- bi_seller_summary: Seller analysis (Page 2) + satisfaction/cancellation (Page 4)
-- Combines 04_seller_analysis.sql with the seller-level satisfaction and
-- cancellation logic from 10_business_opportunities.sql, same grain
CREATE VIEW bi_seller_summary AS
SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    SUM(oi.price) AS revenue,
    COUNT(DISTINCT oi.order_id) AS distinct_orders,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    ROUND(
        100.0 * COUNT(DISTINCT CASE WHEN o.order_status = 'canceled' THEN oi.order_id END)
        / COUNT(DISTINCT oi.order_id)
    , 2) AS cancel_rate_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN sellers s ON oi.seller_id = s.seller_id
LEFT JOIN order_reviews r ON o.order_id = r.order_id
GROUP BY s.seller_id, s.seller_city, s.seller_state;
 

-- bi_state_delivery_summary: Geography + delivery (Page 3)
-- Combines 06_geographic_analysis.sql (revenue by state) with
-- 07_delivery_analysis.sql Step 2 (late-delivery rate by state)
CREATE VIEW bi_state_delivery_summary AS
SELECT
    c.customer_state,
    SUM(op.payment_value) AS revenue,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(
        AVG(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400)::numeric
    , 1) AS avg_delivery_days,
    ROUND(
        100.0 * SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END)
        / COUNT(*)
    , 1) AS late_pct
FROM valid_orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_payments op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state;
 

-- bi_delivery_satisfaction: On-time vs. late review score (Page 4 hero chart)
-- NEW — same logic as 08_customer_satisfaction.sql Step 2, but this exact
-- grain (delivery_status, 2 rows) doesn't exist in any of the other views
CREATE VIEW bi_delivery_satisfaction AS
SELECT
    CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'late'
        ELSE 'on_time'
    END AS delivery_status,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    COUNT(*) AS orders
FROM valid_orders o
JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'late'
        ELSE 'on_time'
    END;
 
 
-- bi_customer_summary: Retention (Page 4)
-- NEW — one row per customer, deliberately LESS aggregated than
-- 09_customer_retention.sql's finished "3%" figure, so Power BI's DAX
-- layer can compute (and slice) the repeat-purchase rate live
CREATE VIEW bi_customer_summary AS
SELECT
    c.customer_unique_id,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(op.payment_value) AS total_spent,
    MIN(o.order_purchase_timestamp) AS first_order_date,
    MAX(o.order_purchase_timestamp) AS last_order_date
FROM valid_orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_payments op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id, c.customer_state;
 

-- Test to verify data
SELECT SUM(monthly_revenue) FROM bi_monthly_revenue;        
SELECT * FROM bi_delivery_satisfaction;                    
SELECT COUNT(*) FROM bi_customer_summary WHERE order_count >= 2;  
























 