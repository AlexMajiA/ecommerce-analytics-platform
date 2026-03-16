select *
from {{ ref("int_sales_order_items")}}
where freight_value < 0


