-- Q4. Which states/cities generate the most sales?

-- Step 1: Revenue by state
SELECT
    c.customer_state,
    SUM(op.payment_value) AS revenue,
    COUNT(DISTINCT o.order_id) AS orders
FROM valid_orders AS o
JOIN customers AS c ON o.customer_id = c.customer_id
JOIN order_payments AS op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY revenue DESC;

-- Step 2: Revenue by city (top markets specifically)
SELECT
    c.customer_city,
    c.customer_state,
    SUM(op.payment_value) AS revenue,
    COUNT(DISTINCT o.order_id) AS orders
FROM valid_orders AS o
JOIN customers AS c ON o.customer_id = c.customer_id
JOIN order_payments AS op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_city, c.customer_state
ORDER BY revenue DESC
LIMIT 10;
