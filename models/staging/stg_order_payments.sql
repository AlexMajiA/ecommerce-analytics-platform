with source as (

    select *
    from {{ source('olist_raw', 'order_payments_raw') }}

),

renamed as (

    select
        order_id,
        payment_sequential,
        payment_type,
        payment_installments,
        payment_value
    from source

)

select *
from renamed