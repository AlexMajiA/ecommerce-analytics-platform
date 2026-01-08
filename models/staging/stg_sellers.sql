with source as (

    select *
    from {{ source('olist_raw', 'sellers_raw') }}

),

renamed as (

    select
        *
    from source

)

select *
from renamed