# Data Engineering Project – ELT Pipeline with dbt & Snowflake

## Overview
This project is a Data Engineering initiative focused on building an ELT pipeline using **dbt** and **Snowflake**, based on a real e-commerce dataset (Olist, Brazil).

The goal is to design a scalable and maintainable data platform oriented to analytics use cases, following best practices in data modeling and transformation.

---

## Current Status
✅ Data ingestion completed in Snowflake  
✅ Staging layer (`stg`) implemented with data cleaning, standardization and validation  
🚧 Analytical modeling layer in progress

---

## Architecture
- **Data Warehouse:** Snowflake  
- **Transformation approach:** ELT  
- **Transformation tool:** dbt  
- **Data layers:**
  - RAW: ingested source data
  - STG: cleaned and standardized staging models
  - (Planned) Analytics layer for business-oriented models

---

## Dataset
Real-world e-commerce dataset including:
- orders
- customers
- payments
- reviews

---

## Project Structure
models/
staging/
macros/
tests/
snapshots/
seeds/

---

## Data Quality & Testing
The project includes:
- basic dbt tests (`not_null`, `unique`)
- source validation
- structured staging models to ensure data consistency

---

## How to Run
```bash
dbt deps
dbt run
dbt test
```
---

## Next Steps

Develop analytical models (facts & dimensions)

Add business metrics

Extend data quality tests

Generate dbt documentation
