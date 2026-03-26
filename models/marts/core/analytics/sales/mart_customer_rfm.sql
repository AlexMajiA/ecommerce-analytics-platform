-- Recency ¿Hace cuánto tiempo compró el cliente?
-- Frequency ¿Con qué frecuencia compra?
-- Monetary ¿Cuánto dinero genera?

{{
    config (materialized = 'table')
}}

with base as (

    select
        customer_unique_id,
        year,
        month,
        recency_days,
        total_orders,
        total_revenue

    from 
        {{ ref('mart_customer_base') }}

),

rfm_scored as (

    select
        *,

        6 - ntile(5) over (
            partition by year, month
            order by recency_days asc
        ) as recency_score,

        6 - ntile(5) over (
            partition by year, month
            order by total_orders desc
        ) as frequency_score,

        6 - ntile(5) over (
            partition by year, month
            order by total_revenue desc
        ) as monetary_score

    from base

)

select
    customer_unique_id,
    year,
    month,
    recency_days,
    total_orders,
    total_revenue,
    recency_score,
    frequency_score,
    monetary_score,
    concat(recency_score, frequency_score, monetary_score) as rfm_segment

from rfm_scored