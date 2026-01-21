{{
    config(
    materialized='view', alias='mv_stg_sellers'
    )
}}

with source as (

    select *
    from {{ source('olist_raw', 'sellers_raw') }}

),

renamed as (

    select
        seller_id,
        seller_zip_code_prefix,
        trim(lower(seller_city))        as seller_city, 
        trim(upper(seller_state))       as seller_state
    from source

)

select *
from renamed