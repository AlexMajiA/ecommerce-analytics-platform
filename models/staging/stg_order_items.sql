with source as (

    select *
    from {{ source('olist_raw', 'order_items_raw') }}

),

renamed as (

    select
        *
    from source

)

select *
from renamed