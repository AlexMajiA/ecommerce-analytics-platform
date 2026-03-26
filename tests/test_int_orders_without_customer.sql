select *
from {{ ref("int_sales_order_items")}}
where 
    customer_id is null