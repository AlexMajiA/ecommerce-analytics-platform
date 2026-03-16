select *
from {{ ref('int_sales_order_items') }}
where price < 0