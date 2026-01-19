{{ 
    config(
    materialized='view', alias='mv_stg_orders'
    ) 
}}

with source as (

    select *
    from {{ source('olist_raw', 'orders_raw') }}

),

renamed as (

    select
        order_id,
        customer_id,
        trim(order_status) as order_status,
        cast(order_purchase_timestamp as TIMESTAMP)         as order_purchase_timestamp,
        cast (order_approved_at as TIMESTAMP)               as order_approved_at,
        cast (order_delivered_carrier_date as TIMESTAMP)    as order_delivered_carrier_date,
        cast (order_delivered_customer_date as TIMESTAMP)   as order_delivered_customer_date,
        cast (order_estimated_delivery_date as DATE)        as order_estimated_delivery_date
    from source

)

select *
from renamed
