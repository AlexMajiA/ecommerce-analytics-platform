## Bronze ingestion – Snowflake

This folder contains the SQL script used to set up the Snowflake environment
and ingest the Olist dataset into the Bronze layer.

### What this script does
The `bronze_ingestion.sql` script performs the following steps:

- Creates the Bronze, Silver and Gold databases
- Creates the required schemas
- Creates a Snowflake warehouse
- Defines an internal stage and CSV file format
- Creates raw tables (Bronze layer)
- Loads data from CSV files using COPY INTO

### Purpose of the Bronze layer
The Bronze layer stores raw data as close as possible to the original source.
No transformations or business logic are applied at this stage.

This layer serves as the immutable source of truth for downstream
transformations handled by dbt.
