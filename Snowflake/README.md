## Bronze ingestion – Snowflake

This folder contains the SQL script used to set up the Snowflake environment
and ingest the Olist dataset into the Bronze layer.

### Data typing strategy in the Bronze layer

All columns in the Bronze layer are ingested as `VARCHAR`.

This is a deliberate design choice to ensure that no data is lost during ingestion,
especially when dealing with raw CSV files that may contain inconsistent or malformed values.

Data type casting and validation are intentionally deferred to the staging layer,
where data quality checks and transformations are applied in a controlled manner using dbt.


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
