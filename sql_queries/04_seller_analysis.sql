-- Q3. Which sellers drive the most revenue, and how concentrated is it

-- Step 1: Top sellers, ranked
SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    SUM(oi.price) AS revenue,
    COUNT(oi.order_item_id) AS items_sold,
    COUNT(DISTINCT oi.order_id) AS distinct_orders,
    RANK() OVER (ORDER BY SUM(oi.price) DESC) AS revenue_rank
FROM valid_orders AS o
JOIN order_items AS oi ON o.order_id = oi.order_id
JOIN sellers AS s ON oi.seller_id = s.seller_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_id, s.seller_city, s.seller_state
ORDER BY revenue DESC
LIMIT 10;

-- Step 2: Revenue concentration — what % of total revenue comes from the top N sellers?
WITH seller_revenue AS (
    SELECT
        oi.seller_id,
        SUM(oi.price) AS revenue
    FROM valid_orders AS o
    JOIN order_items AS oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
),
ranked AS (
    SELECT
        seller_id,
        revenue,
        RANK() OVER (ORDER BY revenue DESC) AS revenue_rank,
        SUM(revenue) OVER (ORDER BY revenue DESC) AS running_total,
        SUM(revenue) OVER () AS grand_total
    FROM seller_revenue
)
SELECT
    revenue_rank,
    ROUND(running_total / grand_total * 100, 1) AS cumulative_pct_of_revenue
FROM ranked
WHERE revenue_rank IN (1, 5, 10, 20, 50, 100)
ORDER BY revenue_rank;

-- Top revenue sellers cross-checked against satisfaction
WITH seller_stats AS (
    SELECT
        oi.seller_id,
        SUM(oi.price) AS revenue,
        COUNT(DISTINCT oi.order_id) AS orders
    FROM valid_orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
),
seller_scores AS (
    SELECT
        oi.seller_id,
        AVG(r.review_score) AS avg_score
    FROM valid_orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN order_reviews r ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
)
SELECT
    ss.seller_id,
    ss.revenue,
    ss.orders,
    ROUND(sc.avg_score, 2) AS avg_review_score,
    ROUND((SELECT AVG(review_score) FROM order_reviews), 2) AS overall_avg_score
FROM seller_stats ss
JOIN seller_scores sc ON ss.seller_id = sc.seller_id
WHERE ss.orders >= 30
ORDER BY ss.revenue DESC
LIMIT 10;