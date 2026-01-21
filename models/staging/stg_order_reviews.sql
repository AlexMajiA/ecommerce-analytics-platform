{{ 
    config(
    materialized='view', alias='mv_stg_order_reviews'
    ) 
}}

with source as (

    select *
    from {{ source('olist_raw', 'order_reviews_raw') }}

),

cleaned as (

    select
        review_id,
        order_id,
        cast(review_score as integer)               as review_score,
        trim(review_comment_title)                  as review_comment_title,
        trim(review_comment_message)                as review_comment_message,
        cast(review_creation_date as DATE)          as review_creation_date,
        cast(review_answer_timestamp as TIMESTAMP)  as review_answer_timestamp
    from source

)

select *
from cleaned