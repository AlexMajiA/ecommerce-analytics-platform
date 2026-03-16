{{
    config( materialized = 'table')
}}

with seller as (
    select
        seller_id,
        seller_zip_code_prefix,
        seller_city,
        seller_state
    from
        {{ ref("stg_sellers")}}

), geolocation as (
    select
        geolocation_zip_code_prefix,
        avg(geolocation_lat) as lat,
        avg(geolocation_lng) as lng

    from {{ ref("stg_geolocation")}}
    group by geolocation_zip_code_prefix

), seller_enrich as(
    select
        s.seller_id,
        s.seller_zip_code_prefix,
        s.seller_city,
        s.seller_state,

        g.lat,
        g.lng
        
    from 
        seller s 

    left join geolocation g
    on s.seller_zip_code_prefix = g.geolocation_zip_code_prefix

)

select * 
from seller_enrich
