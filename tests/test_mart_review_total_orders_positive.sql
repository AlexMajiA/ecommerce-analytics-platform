select *
from {{ ref("mart_review_sentiment") }}
where total_orders <= 0