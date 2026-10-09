-- Q2. Which product categories generate the most revenue and orders?

SELECT
    COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
    SUM(oi.price) AS revenue,
    COUNT(oi.order_item_id) AS items_sold,
    COUNT(DISTINCT oi.order_id) AS distinct_orders
FROM valid_orders AS o
JOIN order_items AS oi ON o.order_id = oi.order_id
LEFT JOIN products AS p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation AS t ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
ORDER BY revenue DESC;

-- Revenue concentration: what % of total revenue comes from the top N categories?
WITH category_revenue AS (
    SELECT
        COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
        SUM(oi.price) AS revenue
    FROM valid_orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    LEFT JOIN products p ON oi.product_id = p.product_id
    LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
    WHERE o.order_status = 'delivered'
    GROUP BY COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
),
ranked AS (
    SELECT
        category,
        revenue,
        RANK() OVER (ORDER BY revenue DESC) AS revenue_rank,
        SUM(revenue) OVER (ORDER BY revenue DESC) AS running_total,
        SUM(revenue) OVER () AS grand_total
    FROM category_revenue
)
SELECT
    revenue_rank,
    ROUND(running_total / grand_total * 100, 1) AS cumulative_pct_of_revenue
FROM ranked
WHERE revenue_rank IN (5, 10, 20, 50, 74)
ORDER BY revenue_rank;