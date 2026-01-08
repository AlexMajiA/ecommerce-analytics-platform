with source as (

    select *
    from {{ source('olist_raw', 'order_payments_raw') }}

),

renamed as (

    select
        *
    from source

)

select *
from renamed