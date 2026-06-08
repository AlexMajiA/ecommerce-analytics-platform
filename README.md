# Data Engineering Project – ELT Pipeline with dbt & Snowflake

## Overview
This project is a Data Engineering initiative focused on building an ELT pipeline using **dbt** and **Snowflake**, based on a real e-commerce dataset (Olist, Brazil).

The objective is to design a scalable and maintainable data platform oriented to analytical use cases, applying best practices in data modeling, transformation, data quality, and AI-powered enrichment.

---

## Current Status
✅ Data ingestion completed in Snowflake  
✅ Staging layer (`stg`) implemented with data cleaning and standardization  
✅ Intermediate layer implemented for reusable transformations  
✅ Core layer implemented (fact and dimension models)  
✅ Analytical layer implemented with multiple business-oriented marts  
✅ Snowflake Cortex AI integration (sentiment analysis + translation)  
🚧 Ongoing improvements and extensions

---

## Architecture

- **Data Warehouse:** Snowflake  
- **Transformation approach:** ELT  
- **Transformation tool:** dbt  

### Data Layers

- **RAW (Bronze)**  
  Source data ingested into Snowflake from AWS S3

- **STAGING (`stg`) — Silver**  
  Data cleaning, normalization and type casting

- **INTERMEDIATE (`int`) — Silver**  
  Reusable transformations to simplify downstream models.  
  Follows the **DRY principle** (Don't Repeat Yourself): complex or expensive calculations are performed once here and inherited by all dependent marts.

- **CORE — Gold**  
  Fact and dimension models:
  - `fct_sales`
  - `dim_customers`
  - `dim_products`
  - `dim_date`
  - `dim_seller`

- **MARTS — Gold**  
  Business-oriented analytical models

---

## Snowflake Cortex AI Integration

This project integrates **Snowflake Cortex AI** functions directly into the dbt pipeline to enrich customer reviews with NLP capabilities.

### Problem
The Olist dataset contains **99,224 customer reviews written in Portuguese**. Analyzing sentiment required both translation and scoring within the pipeline.

### Solution
Two Cortex functions are chained in the `int_order_reviews_enriched` intermediate model:

1. **`AI_TRANSLATE`** — translates each review from Portuguese to English
2. **`SNOWFLAKE.CORTEX.SENTIMENT`** — returns a sentiment score (float between -1 and +1)

NULL values are handled explicitly with `CASE WHEN` to avoid unnecessary Cortex API calls and reduce credit consumption.

```sql
-- Step 1: Translate
CASE
    WHEN review_comment_message IS NOT NULL
    THEN AI_TRANSLATE(review_comment_message, 'pt', 'en')
    ELSE NULL
END AS review_comment_message_translated

-- Step 2: Score sentiment on translated text
CASE
    WHEN review_comment_message_translated IS NOT NULL
    THEN SNOWFLAKE.CORTEX.SENTIMENT(review_comment_message_translated)
    ELSE NULL
END AS review_sentiment
```

### Key decisions
- Materialized as **table** (not view) — Cortex is called once per `dbt run`, not on every query
- Enrichment placed in **intermediate layer** — all sentiment marts inherit from a single source of truth
- **Cross-region inference** required for EU accounts: `ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_EU'`

---

## Data Marts

### Sales
- **`mart_customer_base`** — customer classification (new vs repeat) by month
- **`mart_customer_rfm`** — RFM analysis (Recency, Frequency, Monetary)
- **`mart_sales_daily`** — daily aggregation of sales metrics
- **`mart_sales_by_state`** — sales performance by geographic location
- **`mart_top_products`** — product-level sales analysis
- **`mart_price_history`** — price evolution tracking via SCD2 snapshot

### Sentiment
- **`mart_review_sentiment`** — sentiment metrics per product, seller and month
  - `avg_sentiment` — average Cortex sentiment score
  - `avg_review_score` — average star rating (1–5)
  - `total_orders` — distinct orders count
  - `total_items` — total items sold

- **`mart_category_sentiment`** — sentiment metrics aggregated by product category
  - `avg_sentiment` — average sentiment per category
  - `avg_review_score` — average star rating per category
  - `reviews_text` — count of reviews with text comments
  - `total_orders` — distinct orders per category
  - `total_products` — total items sold per category

---

## Project Structure

```
models/
  staging/
  marts/
    core/
      analytics/
        sales/
        sentiment/
      intermediate/
      sales/
tests/
macros/
seeds/
snapshots/
```

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
- Use of **intermediate models** following the DRY principle
- Cortex AI enrichment materialized as **table** to minimize credit consumption
- Explicit **NULL handling** before Cortex function calls
- Use of **window functions** (`ROW_NUMBER`) for latest state logic
- **LEFT JOIN** when enriching facts to preserve data completeness
- Sentiment enrichment in **intermediate layer** to serve multiple marts from a single calculation

---

## How to Run

> ⚠️ **Note:** Source data is loaded in a private Snowflake account connected to AWS S3 and is not publicly available. To run this project you will need to set up your own Snowflake account and load the [Olist dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) into your RAW layer.

```bash
dbt deps
dbt run
dbt test
```

For EU Snowflake accounts using Cortex AI functions, enable cross-region inference first:

```sql
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_EU';
```

---

## Next Steps

- Add dbt tests for sentiment marts
- Extend `mart_category_sentiment` with time dimension (month/year)
- Build Power BI dashboards consuming Gold layer marts
- Explore incremental models for scalability
- Add model descriptions and dbt docs