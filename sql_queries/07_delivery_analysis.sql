-- Q6. How long does delivery take, and which factors are
--     associated with late deliveries?

-- "Late" = order_delivered_customer_date is after the
-- order_estimated_delivery_date Olist quoted the customer.
-- Uses valid_orders so the known bad date sequences are already
-- excluded.

-- Step 1: Overall delivery time (average + median) and late rate
SELECT
    ROUND(AVG(order_delivered_customer_date - order_purchase_timestamp), 1) AS avg_delivery_days,
    PERCENTILE_CONT(0.5) WITHIN GROUP (
        ORDER BY EXTRACT(DAY FROM order_delivered_customer_date - order_purchase_timestamp)
    ) AS median_delivery_days,
    ROUND(
        100.0 * SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END)
        / COUNT(*)
    , 2) AS late_delivery_pct
FROM valid_orders
WHERE order_status = 'delivered';

-- Step 2: Late-delivery rate by customer state (states with meaningful volume only)
SELECT
    c.customer_state,
    ROUND(AVG(o.order_delivered_customer_date - o.order_purchase_timestamp), 1) AS avg_delivery_days,
    ROUND(
        100.0 * SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END)
        / COUNT(*)
    , 1) AS late_pct,
    COUNT(*) AS orders
FROM valid_orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
HAVING COUNT(*) >= 100
ORDER BY late_pct DESC
LIMIT 10;

-- Step 3: Late-delivery rate by day of week the order was placed
SELECT
    TO_CHAR(order_purchase_timestamp, 'Day') AS purchase_day,
    ROUND(
        100.0 * SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END)
        / COUNT(*)
    , 1) AS late_pct,
    COUNT(*) AS orders
FROM valid_orders
WHERE order_status = 'delivered'
GROUP BY TO_CHAR(order_purchase_timestamp, 'Day'), EXTRACT(DOW FROM order_purchase_timestamp)
ORDER BY EXTRACT(DOW FROM order_purchase_timestamp);
