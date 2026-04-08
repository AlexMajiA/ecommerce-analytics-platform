{{
    config(
        materialized = 'table'
    )
}}

with base as (
    select *
    from
        {{ref("snapshot_order_items")}}
)

select *
from base