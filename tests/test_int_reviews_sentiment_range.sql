select *
from {{ ref('int_order_reviews_enriched') }}
where review_sentiment is not null
  and review_sentiment not between -1 and 1