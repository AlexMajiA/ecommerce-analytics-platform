select *
from 
    {{ ref('mart_customer_rfm') }}
where recency_score not between 1 and 5
   or frequency_score not between 1 and 5
   or monetary_score not between 1 and 5