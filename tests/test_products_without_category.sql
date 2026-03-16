select *
from
    {{ref("dim_products")}}
where   
    product_category_name is null
