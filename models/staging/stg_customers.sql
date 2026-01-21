{{ 
    config(
    materialized='view', alias='mv_stg_customers'
    ) 
}}

with source as (

    select *
    from {{ source('olist_raw', 'customers_raw') }}

),

cleaned as (

    select
        customer_id,
        customer_unique_id,
        cast(customer_zip_code_prefix as INTEGER)   as customer_zip_code_prefix,
        trim(customer_city)                         as customer_city,
        trim(customer_state)                        as customer_state
    from source

)

select *
from cleaned