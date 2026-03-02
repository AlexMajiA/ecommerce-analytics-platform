-- ============================================================================
-- S3-BASED INGESTION FOR BRONZE LAYER (PORTFOLIO-FRIENDLY, "SENIOR" VERSION)
-- ============================================================================
-- This script shows how the same Olist CSVs could be ingested from an
-- external S3 bucket instead of being manually uploaded to an internal stage.
--
-- It assumes:
--   - You have an S3 bucket with the raw CSV files, e.g.:
--       s3://my-analytics-raw/olist/olist_customers_dataset.csv
--   - You have created (or will create) an IAM role that Snowflake can assume.
--
-- IMPORTANT:
--   Replace the placeholders:
--     - <AWS_S3_BUCKET_URL>
--     - <AWS_IAM_ROLE_ARN>
--   with your actual values when using this in a real environment.

-- 1. STORAGE INTEGRATION (SECURE BRIDGE BETWEEN SNOWFLAKE AND S3)
CREATE OR REPLACE STORAGE INTEGRATION OLIST_S3_INT
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = '<AWS_IAM_ROLE_ARN>'
  STORAGE_ALLOWED_LOCATIONS = ('<AWS_S3_BUCKET_URL>');

-- After running the command above once, you typically run:
--   DESC INTEGRATION OLIST_S3_INT;
-- and configure the trust relationship on the AWS side using the values
-- provided by Snowflake (this is manual console / IaC work, not shown here).

-- 2. EXTERNAL STAGE POINTING TO S3
-- Reuse the existing CSV FILE FORMAT defined in 04_file_format_stage.sql
-- (FF_COMMA) so we don't duplicate format definitions.
CREATE OR REPLACE STAGE OLIST_DB_BRONZE.INGEST.OLIST_S3_STAGE_RAW
  URL = '<AWS_S3_BUCKET_URL>'
  STORAGE_INTEGRATION = OLIST_S3_INT
  FILE_FORMAT = OLIST_DB_BRONZE.INGEST.FF_COMMA;

-- Example URL layout you might use:
--   s3://my-analytics-raw/olist/olist_customers_dataset.csv
--   s3://my-analytics-raw/olist/olist_geolocation_dataset.csv
--   ...

-- 3. COPY INTO COMMANDS REUSING THE EXTERNAL STAGE
-- The target tables are the same RAW tables used in 06_copy_into.sql.

-- CUSTOMERS_RAW
COPY INTO OLIST_DB_BRONZE.INGEST.CUSTOMERS_RAW
FROM @OLIST_DB_BRONZE.INGEST.OLIST_S3_STAGE_RAW/olist_customers_dataset.csv
FILE_FORMAT = (FORMAT_NAME = OLIST_DB_BRONZE.INGEST.FF_COMMA);

-- GEOLOCATION_RAW
COPY INTO OLIST_DB_BRONZE.INGEST.GEOLOCATION_RAW
FROM @OLIST_DB_BRONZE.INGEST.OLIST_S3_STAGE_RAW/olist_geolocation_dataset.csv
FILE_FORMAT = (FORMAT_NAME = OLIST_DB_BRONZE.INGEST.FF_COMMA);

-- ORDER_ITEMS_RAW
COPY INTO OLIST_DB_BRONZE.INGEST.ORDER_ITEMS_RAW
FROM @OLIST_DB_BRONZE.INGEST.OLIST_S3_STAGE_RAW/olist_order_items_dataset.csv
FILE_FORMAT = (FORMAT_NAME = OLIST_DB_BRONZE.INGEST.FF_COMMA);

-- ORDER_PAYMENTS_RAW
COPY INTO OLIST_DB_BRONZE.INGEST.ORDER_PAYMENTS_RAW
FROM @OLIST_DB_BRONZE.INGEST.OLIST_S3_STAGE_RAW/olist_order_payments_dataset.csv
FILE_FORMAT = (FORMAT_NAME = OLIST_DB_BRONZE.INGEST.FF_COMMA);

-- ORDER_REVIEWS_RAW
COPY INTO OLIST_DB_BRONZE.INGEST.ORDER_REVIEWS_RAW
FROM @OLIST_DB_BRONZE.INGEST.OLIST_S3_STAGE_RAW/olist_order_reviews_dataset.csv
FILE_FORMAT = (FORMAT_NAME = OLIST_DB_BRONZE.INGEST.FF_COMMA);

-- ORDERS_RAW
COPY INTO OLIST_DB_BRONZE.INGEST.ORDERS_RAW
FROM @OLIST_DB_BRONZE.INGEST.OLIST_S3_STAGE_RAW/olist_orders_dataset.csv
FILE_FORMAT = (FORMAT_NAME = OLIST_DB_BRONZE.INGEST.FF_COMMA);

-- PRODUCTS_RAW
COPY INTO OLIST_DB_BRONZE.INGEST.PRODUCTS_RAW
FROM @OLIST_DB_BRONZE.INGEST.OLIST_S3_STAGE_RAW/olist_products_dataset.csv
FILE_FORMAT = (FORMAT_NAME = OLIST_DB_BRONZE.INGEST.FF_COMMA);

-- SELLERS_RAW
COPY INTO OLIST_DB_BRONZE.INGEST.SELLERS_RAW
FROM @OLIST_DB_BRONZE.INGEST.OLIST_S3_STAGE_RAW/olist_sellers_dataset.csv
FILE_FORMAT = (FORMAT_NAME = OLIST_DB_BRONZE.INGEST.FF_COMMA);

-- CATEGORY_NAME_TRANSLATION_RAW
COPY INTO OLIST_DB_BRONZE.INGEST.CATEGORY_NAME_TRANSLATION_RAW
FROM @OLIST_DB_BRONZE.INGEST.OLIST_S3_STAGE_RAW/product_category_name_translation.csv
FILE_FORMAT = (FORMAT_NAME = OLIST_DB_BRONZE.INGEST.FF_COMMA);

-- ============================================================================
-- OPTIONAL: SNOWPIPE FOR CONTINUOUS INGESTION (ONE EXAMPLE)
-- ============================================================================
-- This shows how you would define a Snowpipe on top of the external stage.
-- For a static portfolio dataset it's not strictly necessary, but it signals
-- that you understand continuous ingestion patterns.

CREATE OR REPLACE PIPE OLIST_DB_BRONZE.INGEST.OLIST_ORDERS_PIPE
  AUTO_INGEST = FALSE
  AS
  COPY INTO OLIST_DB_BRONZE.INGEST.ORDERS_RAW
  FROM @OLIST_DB_BRONZE.INGEST.OLIST_S3_STAGE_RAW/olist_orders_dataset.csv
  FILE_FORMAT = (FORMAT_NAME = OLIST_DB_BRONZE.INGEST.FF_COMMA);

-- In a real setup you would typically set AUTO_INGEST = TRUE and wire S3
-- event notifications to this pipe via AWS + Snowflake configuration.

