{{
    config(
        materialized = 'table'
    )
}}

with base as(
    select 
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state
    from {{ ref('stg_customers') }}
), 
    customer_profile as(
    select 
        customer_unique_id,
        gender,
        birth_date,
        loyalty_tier,
        marketing_opt_in,
        acquisition_channel
    from {{ ref('stg_customer_profile')}}
    ),

    customers_enriched as(
        select
            b.customer_id,
            b.customer_unique_id,

            cp.gender,
            cp.birth_date,

            cp.loyalty_tier,
            cp.marketing_opt_in,
            cp.acquisition_channel,

            b.customer_zip_code_prefix,
            b.customer_city,
            b.customer_state

    from base b
    left join customer_profile cp
        using(customer_unique_id)
    )

select *
from customers_enriched