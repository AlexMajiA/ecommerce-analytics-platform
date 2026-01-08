with source as (

    select *
    from {{ source('olist_raw', 'products_raw') }}

),

renamed as (

    select
        *
    from source

)

select *
from renamed