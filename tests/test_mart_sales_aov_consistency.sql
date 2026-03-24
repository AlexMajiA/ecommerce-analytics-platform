select *
from
    {{ref("mart_sales_by_state")}}
where
    total_orders > 0
and avg_order_value is null