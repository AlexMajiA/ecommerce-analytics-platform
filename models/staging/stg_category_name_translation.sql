with source as (

    select *
    from {{ source('olist_raw', 'category_name_translation_raw') }}

),

renamed as (

    select
        *
    from source

)

select *
from renamed
