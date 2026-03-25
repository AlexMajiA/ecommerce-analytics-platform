select *
from {{ ref('fct_sales') }}
where total_item_amount < 0