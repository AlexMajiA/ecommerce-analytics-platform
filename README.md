# Data Engineering Project – ELT Pipeline with dbt & Snowflake

## Overview
This project is a Data Engineering initiative focused on building an ELT pipeline using **dbt** and **Snowflake**, based on a real e-commerce dataset (Olist, Brazil).

The objective is to design a scalable and maintainable data platform oriented to analytical use cases, applying best practices in data modeling, transformation, and data quality.

---

## Current Status
✅ Data ingestion completed in Snowflake  
✅ Staging layer (`stg`) implemented with data cleaning and standardization  
✅ Intermediate layer implemented for reusable transformations  
✅ Core layer implemented (fact and dimension models)  
✅ Analytical layer implemented with multiple business-oriented marts  
🚧 Ongoing improvements and extensions

---

## Architecture

- **Data Warehouse:** Snowflake  
- **Transformation approach:** ELT  
- **Transformation tool:** dbt  

### Data Layers

- **RAW**  
  Source data ingested into Snowflake

- **STAGING (`stg`)**  
  Data cleaning, normalization and type casting

- **INTERMEDIATE (`int`)**  
  Reusable transformations to simplify downstream models

- **CORE**  
  Fact and dimension models:
  - `fct_sales`
  - `dim_customers`
  - `dim_products`
  - `dim_date`
  - `dim_seller`

- **MARTS**  
  Business-oriented analytical models

---

### Dimensions

- `dim_customers`
- `dim_products`
- `dim_date`
- `dim_seller`

---

### Data Marts

- **mart_customer_analysis**
  - Grain: customer + month
  - Metrics:
    - total_orders
    - total_revenue
  - Features:
    - new vs repeat customer classification
    - latest customer attributes (loyalty tier, gender, etc.)

- **mart_sales_daily**
  - Daily aggregation of sales metrics

- **mart_sales_by_state**
  - Sales performance by geographic location

- **mart_top_products**
  - Product-level sales analysis

---

## Project Structure

models/
  staging/
  intermediate/
  core/
    sales/
  marts/
    core/
      analytics/
        sales/
tests/
macros/
seeds/
snapshots/

---

## Analytical Models

Implemented models:

- `fct_sales`
  - Grain: order item
  - Contains transactional sales data

- `dim_customers`
- `dim_products`
- `dim_date`

- `mart_customer_analysis`
  - Grain: customer + month
  - Metrics:
    - total_orders
    - total_revenue
  - Features:
    - new vs repeat classification
    - latest customer attributes (loyalty tier, gender, etc.)


---

## Data Quality & Testing

The project includes:

### Schema Tests
- `not_null`
- `unique`
- `accepted_values`

### Singular Tests
- Duplicate detection (e.g. customer + month grain)
- Negative revenue checks
- Invalid order counts
- Business rule validations (e.g. customer classification)

---

## Key Design Decisions

- Separation of **facts and dimensions**
- Use of **intermediate models** to simplify transformations
- Use of **window functions** (`ROW_NUMBER`) for latest state logic
- Avoid mixing granularities during aggregation
- Use of LEFT JOIN when enriching facts to preserve data completeness

---

## How to Run

```bash
dbt deps
dbt run
dbt test

---

## Next Steps

- Improve existing marts:
    - optimize queries and performance
    - review grain consistency
- Extend data quality:
    - add tests for fact tables
    - expand business validations
- Improve documentation:
    - dbt docs and lineage
    - model descriptions
- Prepare data for BI consumption (e.g. Power BI dashboards)
- (Optional) Implement incremental models for scalability
