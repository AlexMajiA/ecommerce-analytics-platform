{{
    config(materialized = 'table')
}}

with source as (
    select *
    from
     {{ref("stg_order_reviews")}}
),

translate as (
    select 
    *,
    CASE
        WHEN 
            review_comment_message is not null
        THEN 
            AI_TRANSLATE(review_comment_message,'pt','en')
        ELSE
            null
        END AS review_comment_message_translated
    from    
        source

),

sentiment as (
    select
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_creation_date,
    review_answer_timestamp,
    review_comment_message,
    review_comment_message_translated,
        CASE
            WHEN 
                review_comment_message_translated is not null
            THEN
                SNOWFLAKE.CORTEX.sentiment (review_comment_message_translated)
            ELSE
                null
            END AS review_sentiment
    from
        translate

)

select *
from sentiment

