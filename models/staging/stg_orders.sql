
with source as (

    select *
    from {{ source('olist_raw', 'orders_raw') }}

),

renamed as (

    select
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp,
        order_delivered_customer_date,
        order_estimated_delivery_date
    from source

)

select *
from renamed
