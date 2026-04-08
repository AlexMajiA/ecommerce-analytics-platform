{{
    config (materialized = 'table')
}}

with order_items as (
    select 
        order_id,
        order_item_id,
        product_id,
        seller_id,
        price,
        freight_value,
        ingest_timestamp
    from
        {{ ref("stg_order_items")}}    

), 

orders as (
    select 
        order_id,
        customer_id,
        order_purchase_timestamp
    from
        {{ ref("stg_orders")}}

), 

sales as (
    select
        oi.order_id,
        oi.order_item_id,
        oi.product_id,
        oi.seller_id,
        o.customer_id,

        o.order_purchase_timestamp as order_timestamp,

        oi.price,
        oi.freight_value,     

        oi.price + oi.freight_value as total_item_amount,

        oi.ingest_timestamp

    from
        order_items oi

    left join orders o
    on oi.order_id = o.order_id
)

select *
from
    sales
