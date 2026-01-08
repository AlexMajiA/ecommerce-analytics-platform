with source as (

    select *
    from {{ source('olist_raw', 'geolocation_raw') }}

),

renamed as (

    select
        *
    from source

)

select *
from renamed