select *
from {{ ref('int_order_reviews_enriched') }}
where review_score is not null
  and review_score not between 1 and 5