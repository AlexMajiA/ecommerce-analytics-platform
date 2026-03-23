select *
from
    {{ref("mart_top_products")}}
where
    total_revenue < 0