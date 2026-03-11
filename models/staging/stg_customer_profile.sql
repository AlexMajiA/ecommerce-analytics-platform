{{ 
    config(
    materialized='view', alias='mv_stg_customer_profile'
    ) 
}}

with source as (

    select
        CUSTOMER_UNIQUE_ID,
        gender,
        birth_date,
        signup_date,
        loyalty_tier,
        marketing_opt_in,
        acquisition_channel
    from {{ source('olist_raw', 'customer_profile_raw') }}

),

cleaned as (

    select
        CUSTOMER_UNIQUE_ID          as customer_unique_id,
        gender,
        cast(birth_date as DATE)    as birth_date,
        cast(signup_date as DATE)   as signup_date,
        loyalty_tier,
        marketing_opt_in,
        acquisition_channel
    from source

)

select *
from cleaned