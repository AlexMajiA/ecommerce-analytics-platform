-- número de pedidos por cliente
-- revenue por cliente
-- repeat vs new customers

{{
    config (materialized = 'table')
}}

with base as (
    select
        order_id,
        customer_id,
        date_key,
        total_item_amount
    from
        {{ref("fct_sales")}}
),

customer_enriched as (
    select
        c.customer_id,
        c.customer_unique_id,
        
        c.gender,
        c.birth_date,
        c.loyalty_tier,
        c.marketing_opt_in,
        c.acquisition_channel,


        d.month,
        d.month_name,
        d.year,

        b.order_id,
        b.total_item_amount,
        b.date_key

    from
        base b

    left join {{ref("dim_customers")}} c
    on b.customer_id = c.customer_id

    left join {{ref("dim_date")}} d
    on b.date_key = d.date_key
),

aggregated as (
    select
        customer_unique_id,
        month,
        month_name,
        year,

        count(distinct order_id) as total_orders,
        sum(total_item_amount) as total_revenue
        

    from
        customer_enriched ce

    group by customer_unique_id, month, month_name, year
),

first_order as (
    select
        customer_unique_id,
        to_date(to_varchar(min(date_key)), 'YYYYMMDD') as first_order_date

    from
        customer_enriched
    group by customer_unique_id
),

last_order_day as (
    select
        customer_unique_id,
        to_date(to_varchar(max(date_key)), 'YYYYMMDD') as last_order_date
    from
        customer_enriched
    group by 
        customer_unique_id
),

max_date as (
    select
        to_date(to_varchar(max(date_key)), 'YYYYMMDD') as max_date
    from
        customer_enriched
),


latest_customer as (

    select *
    from (

        select
            *,
            row_number() over (
                partition by customer_unique_id
                order by customer_id desc   -- o created_at si tienes
            ) as rn

        from {{ ref('dim_customers') }}

    )
    where rn = 1
),


customer_type as (
    select
        a.customer_unique_id,
        a.month,
        a.month_name,
        a.year,

        a.total_orders,
        a.total_revenue,
        a.total_revenue / nullif(a.total_orders, 0) as avg_order_value,
        datediff('day', lo.last_order_date, md.max_date) as recency_days,


        fo.first_order_date,

        case
            when year(fo.first_order_date) = a.year
            and month(fo.first_order_date) = a.month
            then 'new'
            else 'repeat'
        end as customer_type,

        c.gender,
        c.birth_date,
        c.loyalty_tier,
        c.marketing_opt_in,
        c.acquisition_channel

    from
        aggregated a

    left join first_order fo
    on a.customer_unique_id = fo.customer_unique_id

left join latest_customer c
on a.customer_unique_id = c.customer_unique_id

    left join last_order_day lo
    on a.customer_unique_id = lo.customer_unique_id

    cross join max_date md
)

select *
from
    customer_type