with source as (

    select *
    from {{ source('olist_raw', 'customers_raw') }}

),

renamed as (

    select
        *
    from source

)

select *
from renamed