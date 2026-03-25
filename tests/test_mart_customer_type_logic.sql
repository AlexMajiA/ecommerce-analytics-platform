select *
from 
    {{ ref('mart_customer_analysis') }}
where customer_type = 'new'
  and total_orders < 1