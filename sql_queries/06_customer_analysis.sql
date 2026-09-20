-- Q5: What is the average order value, and how does it vary by category?

-- Step 1: Overall AOV — average and median

SELECT
    ROUND(AVG(order_total), 2) AS average_order_value,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY order_total), 2) AS median_order_value
FROM (
    SELECT o.order_id, SUM(op.payment_value) AS order_total
    FROM valid_orders o
    JOIN order_payments op ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY o.order_id
) order_totals;

-- Step 2: AOV by category (item price + freight, per distinct order in that category)
SELECT
    COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
    ROUND(SUM(oi.price + oi.freight_value) / COUNT(DISTINCT oi.order_id), 2) AS avg_order_value,
    COUNT(DISTINCT oi.order_id) AS distinct_orders
FROM valid_orders o
JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
HAVING COUNT(DISTINCT oi.order_id) >= 50   -- drop tiny categories so AOV isn't noise from 2-3 orders
ORDER BY avg_order_value DESC;