CREATE TABLE customers (
    customer_id VARCHAR (50),
    customer_unique_id VARCHAR (50),
    customer_zip_code_prefix VARCHAR (5),
    customer_city VARCHAR (100),
    customer_state VARCHAR (10)
);

CREATE TABLE geolocation (
    geolocation_zip_code_prefix VARCHAR (5),
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR (100),
    geolocation_state VARCHAR (10)
);

CREATE TABLE order_items (
    order_id VARCHAR (50),
    order_item_id INT,
    product_id VARCHAR (50),
    seller_id VARCHAR (50),
    shipping_limit_date TIMESTAMP,
    price NUMERIC,
    freight_value NUMERIC
    );

CREATE TABLE order_payments (
    order_id VARCHAR (50),
    payment_sequential INT,
    payment_type TEXT,
    payment_installments INT,
    payment_value NUMERIC
);

CREATE TABLE order_reviews (
    review_id VARCHAR (50),
    order_id VARCHAR (50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATE,
    review_answer_timestamp TIMESTAMP
);

CREATE TABLE orders (
    order_id VARCHAR (50),
    customer_id VARCHAR (50),
    order_status TEXT,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE products (
    product_id VARCHAR (50),
    product_category_name TEXT,
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

CREATE TABLE sellers (
    seller_id VARCHAR (50),
    seller_zip_code_prefix VARCHAR (5),
    seller_city VARCHAR (100),
    seller_state VARCHAR (10)
);

CREATE TABLE product_category_name_translation (
    product_category_name TEXT,
    product_category_name_english TEXT
);