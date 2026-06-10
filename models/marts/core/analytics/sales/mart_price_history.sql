{{ config(materialized="table") }}

with
    base as (
        select order_id, order_item_id, price, dbt_valid_from, dbt_valid_to

        from {{ ref("snapshot_order_items") }}

    ),
    aggregated as (
        select
            order_id,
            order_item_id,

            row_number() over (
                partition by order_id, order_item_id order by dbt_valid_from
            ) as version,

            price,

            lag(price) over (
                partition by order_id, order_item_id order by dbt_valid_from
            ) as previous_price,

            dbt_valid_from,
            dbt_valid_to

        from base

    ),
    final as (
        select
            order_id,
            order_item_id,
            version,
            price,
            previous_price,

            price - previous_price as change,

            datediff(
                day, dbt_valid_from, coalesce(dbt_valid_to, current_timestamp)
            ) as duration_days,

            case when dbt_valid_to is null then true else false end as is_current

        from aggregated
    )

select *
from final
