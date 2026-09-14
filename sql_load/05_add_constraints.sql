-- Data fix required for the Foreign Key to succed.

INSERT INTO product_category_name_translation (product_category_name, product_category_name_english)
VALUES 
    ('pc_gamer', 'pc_gamer'),
    ('portateis_cozinha_e_preparadores_de_alimentos', 'Kitchen Appliances & Food Processors');

-- Adding Primary Keys

ALTER TABLE customers
    ADD CONSTRAINT pk_customer
    Primary Key (customer_id);

ALTER TABLE order_items
    ADD CONSTRAINT pk_order_items
    Primary KEY (order_id, order_item_id);

ALTER TABLE order_payments
    ADD CONSTRAINT pk_order_payments
    Primary Key (order_id, payment_sequential);

ALTER TABLE products
    ADD CONSTRAINT pk_products
    PRIMARY KEY (product_id);

ALTER TABLE sellers
    ADD CONSTRAINT pk_sellers
    PRIMARY KEY (seller_id);

ALTER TABLE product_category_name_translation
    ADD CONSTRAINT pk_category_translation
    PRIMARY KEY (product_category_name);

ALTER TABLE orders
    ADD CONSTRAINT pk_orders
    PRIMARY KEY (order_id);

-- No PRIMARY KEY on order_reviews.review_id - 814 duplicate values (see data_quality.sql)
-- No PRIMARY KEY on geolocation - no natural unique column; duplication is expected

-- Adding Foreign Keys

ALTER TABLE orders
    ADD CONSTRAINT fk_orders_customer 
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id);

ALTER TABLE order_items
    ADD CONSTRAINT fk_items_order FOREIGN KEY (order_id) REFERENCES orders (order_id),
    ADD CONSTRAINT fk_items_product FOREIGN KEY (product_id) REFERENCES products (product_id),
    ADD CONSTRAINT fk_items_seller FOREIGN KEY (seller_id) REFERENCES sellers (seller_id);

ALTER TABLE order_payments
    ADD CONSTRAINT fk_payments_order 
    FOREIGN KEY (order_id) REFERENCES orders (order_id);

ALTER TABLE order_reviews
    ADD CONSTRAINT fk_reviews_order 
    FOREIGN KEY (order_id) REFERENCES orders (order_id);

ALTER TABLE products
    ADD CONSTRAINT fk_products_category 
    FOREIGN KEY (product_category_name) REFERENCES product_category_name_translation (product_category_name);


-- Checking constraints on ranges verified clean in 04_data_quality.sql

ALTER TABLE order_reviews
    ADD CONSTRAINT chk_review_score_range CHECK (review_score BETWEEN 1 AND 5);

ALTER TABLE order_items
    ADD CONSTRAINT chk_price_nonneg CHECK (price >= 0),
    ADD CONSTRAINT chk_freight_nonneg CHECK (freight_value >= 0);

ALTER TABLE order_payments
    ADD CONSTRAINT chk_payment_value_nonneg CHECK (payment_value >= 0);



