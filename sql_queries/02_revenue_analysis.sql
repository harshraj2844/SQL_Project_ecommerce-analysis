-- NOTE : 
-- excludes 2016-12 (single test order) in Step 2/3 and 
-- 2018-09/2018-10 (incomplete — dataset ends before these orders could be delivered)
-- from any trend interpretation.


-- Q1. How much revenue does Olist generate, and how has it changed over time?
-- Revenue = total payment value from delivered orders only (see 01_create_ciews.sql)

-- 1: Total revenue

SELECT SUM(op.payment_value) AS total_revenue
FROM valid_orders AS o
JOIN order_payments AS op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered';

-- 2: Revenue by month, oldest to newest
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    SUM(op.payment_value) AS monthly_revenue
FROM valid_orders AS o
JOIN order_payments AS op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
 AND o.order_purchase_timestamp >= '2017-01-01'
 AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
ORDER BY month;

-- 3: Month-over-month growth rate
SELECT
    month,
    monthly_revenue,
    LAG(monthly_revenue) OVER (ORDER BY month) AS previous_month_revenue,
    ROUND(
        (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month))
        / LAG(monthly_revenue) OVER (ORDER BY month) * 100
    , 1) AS growth_pct
FROM (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        SUM(op.payment_value) AS monthly_revenue
    FROM valid_orders AS o
    JOIN order_payments AS op ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
        AND o.order_purchase_timestamp >= '2017-01-01'
        AND o.order_purchase_timestamp < '2018-09-01'
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
) AS monthly
ORDER BY month;

