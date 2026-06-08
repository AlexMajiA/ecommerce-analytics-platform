{{
    config(materialized = 'table')
}}

with reviews as (
    select *
    from
        {{ref("int_order_reviews_enriched")}}
),

order_items as (
    select *
    from
        {{ref("int_sales_order_items")}}
),

final as (
    select
        oi.product_id,
        oi.seller_id,
        
        DATE_TRUNC('month', oi.order_timestamp) as month_year,

        avg(r.review_sentiment)   as avg_review_sentiment,
        avg(r.review_score)       as avg_review_score,
        count(oi.product_id)      as total_orders

    from
        order_items oi
    
    left join   
        reviews r
    on oi.order_id = r.order_id

    group by(oi.product_id, oi.seller_id, DATE_TRUNC('month', oi.order_timestamp))

)

select *
from
    final



