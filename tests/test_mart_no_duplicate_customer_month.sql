select
    customer_unique_id,
    year,
    month,
    count(*) as num_records
from 
    {{ ref('mart_customer_analysis') }}
    
group by customer_unique_id, year, month
having count(*) > 1