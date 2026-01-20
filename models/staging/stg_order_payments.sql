{{ 
    config(
    materialized='view', alias='mv_stg_orders_payments'
    ) 
}}
with source as (

    select *
    from {{ source('olist_raw', 'order_payments_raw') }}

),

renamed as (

    select
        order_id,
        payment_sequential,
        trim(lower(payment_type))                                       as payment_type,
        cast(payment_installments as integer)                           as payment_installments,
        cast(trim(replace(payment_value, ',','.')) as decimal (10,2))   as payment_value
    from source

)

select *
from renamed