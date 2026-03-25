select *
from 
    {{ ref('mart_customer_analysis') }}
where total_orders <= 0