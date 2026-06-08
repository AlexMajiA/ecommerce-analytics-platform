select *
from {{ ref("mart_review_sentiment") }}
where avg_review_sentiment is not null
  and avg_review_sentiment not between -1 and 1