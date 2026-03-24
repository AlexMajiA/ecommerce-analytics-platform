select *
from
    {{ref("mart_sales_by_state")}}
where
    customer_state is null
