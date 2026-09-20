-- Q7. How satisfied are customers, and what factors are
--     associated with low review scores?


-- Step 1: Overall review score distribution
SELECT
    review_score,
    COUNT(*) AS reviews,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_reviews
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;

-- Step 2: Average review score, on-time vs. late delivery
-- (the single strongest factor tested)
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

-- Step 3: Lowest-rated product categories (meaningful volume only)
SELECT
    COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    COUNT(DISTINCT oi.order_id) AS orders
FROM valid_orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN order_reviews r ON o.order_id = r.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
HAVING COUNT(DISTINCT oi.order_id) >= 50
ORDER BY avg_review_score ASC
LIMIT 10;