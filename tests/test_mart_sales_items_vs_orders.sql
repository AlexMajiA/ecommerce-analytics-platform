select *
from
    {{ref("mart_sales_by_state")}}
where
    total_items_sold < total_orders