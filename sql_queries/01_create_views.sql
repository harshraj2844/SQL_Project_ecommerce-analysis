-- A view that excludes orders with logically-impossible date sequences
-- (found in sql_load/04_data_quality.sql: 1,359 shipped-before-approved,
-- 23 delivered-before-shipped, 8 delivered-status-but-no-date)

CREATE VIEW valid_orders AS
SELECT *
FROM orders
WHERE NOT (
    order_delivered_carrier_date < order_approved_at
    OR order_delivered_customer_date < order_delivered_carrier_date
    OR (order_status = 'delivered' AND order_delivered_customer_date IS NULL)
);

