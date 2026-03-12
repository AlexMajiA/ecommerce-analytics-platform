{{
    config (materialized = 'table')
}}

with products as(
    select
        product_id,
        product_category_name,
        product_weight_g,
        product_length_cm,
        product_height_cm,
        product_width_cm
    from {{ ref("stg_products")}}

), translation as(
    select
        product_category_name,
        product_category_name_english
    from {{ ref("stg_category_name_translation")}}

), products_enriched as(
    select
        p.product_id,
        p.product_category_name,
        t.product_category_name_english,
        p.product_weight_g,
        p.product_length_cm,
        p.product_height_cm,
        p.product_width_cm

    from
        products p
    left join translation t
    on p.product_category_name = t.product_category_name
)

select * 
from products_enriched