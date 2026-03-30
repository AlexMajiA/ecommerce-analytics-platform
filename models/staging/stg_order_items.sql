{{
    config(
        materialized='incremental',
        unique_key=['order_id','order_item_id'],
        incremental_strategy='merge'
    )
}}

with source as (

    select 
        order_id,
        order_item_id,
        product_id,
        seller_id,
        shipping_limit_date,
        price,
        freight_value,
        ingest_timestamp,
        batch_id,
        source_file
    from {{ source('olist_raw', 'order_items_raw_ingested') }}

    {% if is_incremental() %}
    where source.batch_id is not null
      and not exists (
          select 1
          from {{ this }} t
          where t.batch_id = source.batch_id
      )
    {% endif %}

),

cleaned as (

    select
        order_id,
        cast(order_item_id as INTEGER)                                as order_item_id,
        product_id,
        seller_id,
        cast(shipping_limit_date as TIMESTAMP)                        as shipping_limit_date,
        cast(trim(replace(price, ',', '.')) as decimal(10,2))         as price,
        cast(trim(replace(freight_value, ',', '.')) as decimal(10,2)) as freight_value,
        ingest_timestamp,
        batch_id,
        source_file
    from source

),

deduplicated as (

    select *
    from cleaned
    qualify row_number() over (
        partition by order_id, order_item_id
        order by ingest_timestamp desc
    ) = 1

)

select *
from deduplicated