-- Q8. Do customers tend to make repeat purchases, and what
--     does retention look like?

-- Here we group by customer_unique_id, NOT customer_id.
-- customer_id is generated fresh per order, so grouping by it
-- would always show zero repeat customers by definition.

-- Step 1: Repeat purchase rate
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM valid_orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN order_count >= 2 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(100.0 * SUM(CASE WHEN order_count >= 2 THEN 1 ELSE 0 END) / COUNT(*), 2) AS repeat_purchase_rate_pct,
    MAX(order_count) AS most_orders_by_one_customer
FROM customer_orders;

-- Step 2: Revenue share coming from repeat customers
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM valid_orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
customer_revenue AS (
    SELECT
        c.customer_unique_id,
        SUM(op.payment_value) AS total_spent
    FROM valid_orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN order_payments op ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN co.order_count >= 2 THEN cr.total_spent ELSE 0 END)
        / SUM(cr.total_spent)
    , 1) AS repeat_customer_revenue_share_pct
FROM customer_orders co
JOIN customer_revenue cr ON co.customer_unique_id = cr.customer_unique_id;
