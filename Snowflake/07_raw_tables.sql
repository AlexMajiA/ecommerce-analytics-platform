USE DATABASE OLIST_DB_BRONZE;
USE SCHEMA INGEST;

DESC TABLE OLIST_DB_BRONZE.INGEST.ORDERS_RAW;

--CREACION DE TABLAS
CREATE OR REPLACE TABLE CUSTOMERS_RAW (
customer_id VARCHAR (80),
customer_unique_id VARCHAR (80),
customer_zip_code_prefix VARCHAR (20), 
customer_city VARCHAR (150),
customer_state VARCHAR (10)
);

CREATE OR REPLACE TABLE GEOLOCATION_RAW (
geolocation_zip_code_prefix VARCHAR(80),
geolocation_lat VARCHAR(80),
geolocation_lng VARCHAR(80),
geolocation_city VARCHAR(80) ,
geolocation_state VARCHAR(10)
);

CREATE OR REPLACE TABLE ORDER_ITEMS_RAW (
order_id VARCHAR(150),
order_item_id VARCHAR(150),
product_id VARCHAR(150),
seller_id VARCHAR(150),
shipping_limit_date VARCHAR(150),
price VARCHAR(40), 
freight_value VARCHAR(150)
);

CREATE OR REPLACE TABLE ORDER_PAYMENTS_RAW (
order_id VARCHAR(150),
payment_sequential VARCHAR(50),
payment_type VARCHAR(50),
payment_installments VARCHAR(50), 
payment_value VARCHAR(50)
);

CREATE OR REPLACE TABLE ORDER_REVIEWS_RAW (
review_id VARCHAR(150),
order_id VARCHAR(150),
review_score VARCHAR(150),
review_comment_title VARCHAR(150),
review_comment_message VARCHAR,
review_creation_date VARCHAR(150),
review_answer_timestamp VARCHAR(150)
);

CREATE OR REPLACE TABLE ORDERS_RAW (
order_id VARCHAR(150),
customer_id VARCHAR(150),
order_status VARCHAR(150), 
order_purchase_timestamp VARCHAR(150),
order_approved_at VARCHAR(150),
order_delivered_carrier_date VARCHAR(150),
order_delivered_customer_date VARCHAR(150),
order_estimated_delivery_date VARCHAR(150)
);

CREATE OR REPLACE TABLE PRODUCTS_RAW (
product_id VARCHAR(150), 
product_category_name VARCHAR(150),
product_name_lenght VARCHAR(150),
product_description_lenght VARCHAR(150),
product_photos_qty VARCHAR(100),
product_weight_g VARCHAR(100),
product_length_cm VARCHAR(100),
product_height_cm VARCHAR(100),
product_width_cm VARCHAR(100)
);

CREATE OR REPLACE TABLE SELLERS_RAW (
seller_id VARCHAR(100), 
seller_zip_code_prefix VARCHAR(100),
seller_city VARCHAR(50),
seller_state VARCHAR(50)
);

CREATE OR REPLACE TABLE CATEGORY_NAME_TRANSLATION_RAW (
product_category_name VARCHAR(150),
product_category_name_english VARCHAR(150)
);

-- MOSTRAR TABLAS PARA COMPROBAR
SHOW TABLES IN SCHEMA OLIST_DB_BRONZE.INGEST;