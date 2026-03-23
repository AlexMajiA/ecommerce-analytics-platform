{{
    config (materialized = 'table')
}}

with base as (
    select
        order_id,
        customer_id,
        order_item_id,
        product_id,
        date_key,
        total_item_amount

    from
        {{ref("fct_sales")}}
),

sales_enriched as (
    select
        b.order_id,
        b.total_item_amount,

        c.customer_id,
        c.customer_zip_code_prefix,
        c.customer_city,
        c.customer_state,

        d.year,
        d.month,
        d.month_name
        
    from
        base b

    inner join {{ref("dim_customers")}} c
    on b.customer_id = c.customer_id

    inner join {{ ref("dim_date")}} d
    on b.date_key = d.date_key

), 

sales_aggregated as (
    select
        customer_state,
        year,
        month,
        month_name,

        sum(total_item_amount) as total_revenue,
        coalesce(
                sum(total_item_amount) / nullif(count(distinct order_id), 0),
                0
            ) as avg_order_value,
        count(distinct order_id) as total_orders,
        count(*) as total_items_sold
        
    from
        sales_enriched

    group by customer_state, year, month, month_name  
)

select *
from
    sales_aggregated