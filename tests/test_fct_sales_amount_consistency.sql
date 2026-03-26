select *
from
    {{ref("fct_sales")}}
where abs((price + freight_value) - total_item_amount) > 0.01

--Añado tolerancia