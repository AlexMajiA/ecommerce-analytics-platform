{{
    config (materialized = 'table')
}}

-- Total de ventas,pedidos y nº de productos por día

with sales_enriched as (
    select
        d.date_key,
        d.month,
        d.month_name,
        d.year,
        d.day_of_week,
        d.day_name,

        s.total_item_amount,
        s.order_id

    from
        {{ ref("fct_sales")}} s

    inner join {{ref("dim_date")}} d
    on d.date_key = s.date_key

),

aggregated as (
    select
        date_key,
        year,
        month,
        month_name,
        day_of_week,
        day_name,

        sum(total_item_amount) as total_revenue,
        count(distinct order_id) as total_orders,
        count(*) as number_items

    from
        sales_enriched
    group by date_key, month, month_name, year, day_of_week, day_name
    order by date_key

)

select *
from
    aggregated


