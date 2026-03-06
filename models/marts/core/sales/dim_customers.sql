{{
    config(
        materialized = 'table'
        
    )
}}

with base as(
    select distinct
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state
    from {{ ref('stg_customers') }}
), 
    customers as(
        select *
        from base
    )

select *
from customers