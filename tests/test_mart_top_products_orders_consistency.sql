select *
from
    {{ref("mart_top_products")}}
where
    total_orders > total_items_sold