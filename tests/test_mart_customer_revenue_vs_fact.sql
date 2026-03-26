select
    sum(total_revenue) as mart_revenue
from 
    {{ ref('mart_customer_base') }}

having mart_revenue != (
    select 
        sum(total_item_amount)
    from 
        {{ ref('fct_sales') }}
)