select *
from 
    {{ ref('mart_customer_analysis') }}
where gender is null
   or loyalty_tier is null