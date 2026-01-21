{{
    config(
        materialized='view', alias='mv_stg_category_name_translation'
    )
}}

with source as (

    select *
    from {{ source('olist_raw', 'category_name_translation_raw') }}

),

renamed as (

    select
        trim(lower(replace(product_category_name,'_',' ')))             as product_category_name,
        trim(lower(replace(product_category_name_english,'_',' ')))     as product_category_name_english     
    from source

)

select *
from renamed
