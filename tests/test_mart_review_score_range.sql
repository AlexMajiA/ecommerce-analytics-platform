select *
from {{ ref("mart_review_sentiment") }}
where avg_review_score is not null
  and avg_review_score not between 1 and 5