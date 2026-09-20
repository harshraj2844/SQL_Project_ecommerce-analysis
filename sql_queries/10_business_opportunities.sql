-- Q9. Which product categories or sellers have the highest
--     cancellation/late-delivery rates?
-- Q10. Which categories/sellers have strong sales but poor
--      customer satisfaction or delivery performance?


-- Step 1 (Q9): Cancellation rate by product category
SELECT
    COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(DISTINCT CASE WHEN o.order_status = 'canceled' THEN oi.order_id END) AS canceled_orders,
    ROUND(
        100.0 * COUNT(DISTINCT CASE WHEN o.order_status = 'canceled' THEN oi.order_id END)
        / COUNT(DISTINCT oi.order_id)
    , 2) AS cancel_rate_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
GROUP BY COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
HAVING COUNT(DISTINCT oi.order_id) >= 50
ORDER BY cancel_rate_pct DESC
LIMIT 8;

-- Step 2 (Q9): Cancellation rate by seller
SELECT
    oi.seller_id,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(DISTINCT CASE WHEN o.order_status = 'canceled' THEN oi.order_id END) AS canceled_orders,
    ROUND(
        100.0 * COUNT(DISTINCT CASE WHEN o.order_status = 'canceled' THEN oi.order_id END)
        / COUNT(DISTINCT oi.order_id)
    , 2) AS cancel_rate_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY oi.seller_id
HAVING COUNT(DISTINCT oi.order_id) >= 30
ORDER BY cancel_rate_pct DESC
LIMIT 8;

-- Step 3 (Q10): Top revenue categories cross-checked against satisfaction
WITH category_stats AS (
    SELECT
        COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
        SUM(oi.price) AS revenue,
        COUNT(DISTINCT oi.order_id) AS orders
    FROM valid_orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    LEFT JOIN products p ON oi.product_id = p.product_id
    LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
    WHERE o.order_status = 'delivered'
    GROUP BY COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
),
category_scores AS (
    SELECT
        COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
        AVG(r.review_score) AS avg_score
    FROM valid_orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN order_reviews r ON o.order_id = r.order_id
    LEFT JOIN products p ON oi.product_id = p.product_id
    LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
    WHERE o.order_status = 'delivered'
    GROUP BY COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
)
SELECT
    cs.category,
    cs.revenue,
    cs.orders,
    ROUND(csc.avg_score, 2) AS avg_review_score,
    ROUND((SELECT AVG(review_score) FROM order_reviews), 2) AS overall_avg_score
FROM category_stats cs
JOIN category_scores csc ON cs.category = csc.category
WHERE cs.orders >= 50
ORDER BY cs.revenue DESC
LIMIT 15;