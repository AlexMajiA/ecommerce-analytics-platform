{{
    config(
        materialized = 'table'
    )
}}

WITH base AS (
    SELECT 
        order_id,
        order_item_id,
        price,
        dbt_valid_from,
        dbt_valid_to
        
    FROM
        {{ref("snapshot_order_items")}}
 
), aggregated AS (
    SELECT 
        order_id,
        order_item_id,

    ROW_NUMBER() OVER(
        PARTITION BY order_id, order_item_id
        ORDER BY dbt_valid_from
    ) AS version,

    price,

    LAG(price) OVER(
        PARTITION BY order_id, order_item_id
        ORDER BY dbt_valid_from
    ) AS previous_price,

    dbt_valid_from,
    dbt_valid_to
        
    FROM 
        base

), final AS (
    SELECT
        order_id,
        order_item_id,
        version,
        price,
        previous_price,

        price - previous_price AS change,

    DATEDIFF(
        day,
        dbt_valid_from,
        coalesce(dbt_valid_to, current_timestamp)
    ) AS duration_days,

    CASE
        WHEN dbt_valid_to is null
        THEN true
        ELSE false
    END AS is_current

FROM
    aggregated
)

SELECT *
FROM final