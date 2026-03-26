select *
from 
    {{ ref('mart_customer_base') }}
where total_orders > 0
  and avg_order_value is null