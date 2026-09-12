COPY customers
FROM 'D:\SQL_Project_ecommerce-analysis\csv_files\olist_customers_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY geolocation
FROM 'D:\SQL_Project_ecommerce-analysis\csv_files\olist_geolocation_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY order_items
FROM 'D:\SQL_Project_ecommerce-analysis\csv_files\olist_order_items_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY order_payments
FROM 'D:\SQL_Project_ecommerce-analysis\csv_files\olist_order_payments_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY order_reviews
FROM 'D:\SQL_Project_ecommerce-analysis\csv_files\olist_order_reviews_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY orders 
FROM 'D:\SQL_Project_ecommerce-analysis\csv_files\olist_orders_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY products
FROM 'D:\SQL_Project_ecommerce-analysis\csv_files\olist_products_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY sellers
FROM 'D:\SQL_Project_ecommerce-analysis\csv_files\olist_sellers_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY product_category_name_translation
FROM 'D:\SQL_Project_ecommerce-analysis\csv_files\product_category_name_translation.csv'
DELIMITER ','
CSV HEADER;
