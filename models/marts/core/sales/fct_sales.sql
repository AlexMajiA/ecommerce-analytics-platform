{{
    config (materialized = 'table')
}}


with sales_order_items as (
    select
        so.order_id,
        so.order_item_id,

        so.product_id,
        so.seller_id,
        so.customer_id,

        d.date_key,
                
        so.price,
        so.freight_value,
        so.total_item_amount
    from
        {{ ref("int_sales_order_items")}} so

    left join {{ ref("dim_date")}} d
    on cast(so.order_timestamp as date) = cast(d.date_day as date)
)

select *
from
    sales_order_items
