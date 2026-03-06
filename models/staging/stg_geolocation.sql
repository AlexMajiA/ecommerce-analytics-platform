{{
    config(
        materialized='view', alias='mv_stg_geolocation'
    )
}}

with source as (

    select 
        geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng,
        geolocation_city,
        geolocation_state
    from {{ source('olist_raw', 'geolocation_raw') }}

),

cleaned as (

    select
        geolocation_zip_code_prefix,
        cast(geolocation_lat as decimal(18,15))     as geolocation_lat,
        cast(geolocation_lng as decimal(18,15))     as geolocation_lng,
        trim(lower(geolocation_city))               as geolocation_city,
        trim(upper(geolocation_state))              as geolocation_state
    from source

)

select *
from cleaned