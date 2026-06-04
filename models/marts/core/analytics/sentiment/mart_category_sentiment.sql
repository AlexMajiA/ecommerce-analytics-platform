{{
    config (materialized = 'table')
}}

with reviews_enriched as (
    select *
    from
    {{ ref("int_order_reviews_enriched")}}
),

dim_products as (
    select *
    from
    {{ref("dim_products")}}

),

sales_order_items as(
    select *
    from
     {{ref("int_sales_order_items")}}
),

joined_data as(
    select 
        dp.product_category_name_english,
        re.review_sentiment,
        re.review_score,
        re.review_comment_message,
        oi.order_id,
        oi.order_item_id

    from
    sales_order_items oi

    left join reviews_enriched re
        on oi.order_id = re.order_id

    left join dim_products dp
        on oi.product_id = dp.product_id
),

aggregated as (
    select
        product_category_name_english,

        avg(review_sentiment)            as avg_sentiment,
        avg(review_score)                as avg_score,
        count(review_comment_message)    as reviews_text,
        count(distinct order_id)         as total_orders,
        count(order_item_id)             as total_products
    from
        joined_data

    group by product_category_name_english
)

select *
from
    aggregated