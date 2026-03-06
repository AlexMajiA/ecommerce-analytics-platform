{{ 
    config(
    materialized='view', alias='mv_stg_products'
    ) 
}}

with source as (

    select 
        product_id,
        product_category_name,
        product_name_lenght,
        product_description_lenght,
        product_photos_qty,
        product_weight_g,
        product_length_cm,
        product_height_cm,
        product_width_cm
    from {{ source('olist_raw', 'products_raw') }}

),

cleaned as (

    select
        product_id,
        trim(lower(replace(product_category_name,'_',' ')))     as product_category_name,
        cast(product_name_lenght as integer)                    as product_name_lenght,
        cast(product_description_lenght as integer)             as product_description_lenght,
        cast(product_photos_qty as integer)                     as product_photos_qty,
        cast(product_weight_g as integer)                       as product_weight_g,
        cast(product_length_cm as integer)                      as product_length_cm,
        cast(product_height_cm as integer)                      as product_height_cm,
        cast(product_width_cm as integer)                       as product_width_cm
    from source

)

select *
from cleaned