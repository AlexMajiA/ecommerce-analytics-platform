select *
from    
    {{ref("mart_sales_by_state")}}
where
    total_revenue < 0