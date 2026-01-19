with source as (

    select *
    from {{ source('olist_raw', 'order_items_raw') }}

),

renamed as (

    select
        order_id,
        cast (order_item_id as INTEGER)                                 as order_item_id,
        product_id,
        seller_id,
        cast(shipping_limit_date as TIMESTAMP)                          as shipping_limit_date,
        cast(trim(replace(price, ',','.')) as decimal(10,2))          as price,
        cast(trim(replace(freight_value, ',','.')) as decimal(10,2))  as freight_value
    from source

)

select *
from renamed