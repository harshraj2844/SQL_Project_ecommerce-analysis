-- Adding Indexes

CREATE INDEX idx_orders_customer_id ON orders (customer_id);
CREATE INDEX idx_order_items_product_id ON order_items (product_id);
CREATE INDEX idx_order_items_seller_id ON order_items (seller_id);
CREATE INDEX idx_order_reviews_order_id ON order_reviews (order_id);
CREATE INDEX idx_products_category_name ON products (product_category_name);
CREATE INDEX idx_geolocation_zip ON geolocation (geolocation_zip_code_prefix);