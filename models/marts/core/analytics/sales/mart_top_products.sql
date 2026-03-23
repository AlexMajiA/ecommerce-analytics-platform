{{
    config (materialized = 'table')
}}

with base as(
    select
        order_id,
        product_id,
        total_item_amount,
        date_key

    from
        {{ref("fct_sales")}} 

), 

base_enriched as(
    select
        p.product_id,
        p.product_category_name,
        p.product_category_name_english,

        d.year,
        d.month,
        d.month_name,

        b.order_id,
        b.total_item_amount

    from
        base b

    inner join {{ref("dim_products")}} p
    on b.product_id = p.product_id

    inner join  {{ref("dim_date")}} d
    on b.date_key = d.date_key

), 

aggregated as (
    select
        product_id,
        product_category_name,
        product_category_name_english,
        year,
        month,
        month_name,

        sum(total_item_amount) as total_revenue,
        count(distinct order_id) as total_orders,
        count(*) as total_items_sold

    from
        base_enriched

    group by product_id, product_category_name, product_category_name_english, year, month, month_name

)

select *
from
    aggregated
    