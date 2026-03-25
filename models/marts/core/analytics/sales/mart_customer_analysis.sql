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

    inner join {{ref("dim_customers")}} c
    on b.customer_id = c.customer_id

    inner join {{ref("dim_date")}} d
    on b.date_key = d.date_key
),

latest_customer as (
    select *
    from (
        select
            customer_id,
            customer_unique_id,
            
            gender,
            birth_date,
            loyalty_tier,
            marketing_opt_in,
            acquisition_channel,

            date_key,
        
            row_number() over(
                partition by customer_unique_id
                order by date_key desc
            ) as rn
    from
        customer_enriched
    )
    where rn =1
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
        min(date_key) as first_order_date

    from
        customer_enriched
    group by customer_unique_id
),

customer_type as (
    select
        a.customer_unique_id,
        a.month,
        a.month_name,
        a.year,

        a.total_orders,
        a.total_revenue,

        to_date(to_varchar(fo.first_order_date), 'YYYYMMDD') as first_order_date,

        case
            when year(to_date(to_varchar(fo.first_order_date), 'YYYYMMDD')) = a.year
            and month(to_date(to_varchar(fo.first_order_date), 'YYYYMMDD')) = a.month
            then 'new'
            else 'repeat'
        end as customer_type,

        lc.gender,
        lc.birth_date,
        lc.loyalty_tier,
        lc.marketing_opt_in,
        lc.acquisition_channel

    from
        aggregated a

    left join first_order fo
    on a.customer_unique_id = fo.customer_unique_id

    left join latest_customer lc
    on a.customer_unique_id = lc.customer_unique_id
)

select *
from
    customer_type