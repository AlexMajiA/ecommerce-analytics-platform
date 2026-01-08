with source as (

    select *
    from {{ source('olist_raw', 'category_name_translation_raw') }}

),

renamed as (

    select
        product_category_name,
        product_category_name_english
    from source

)

select *
from renamed
