{{
    config( materialized = 'table')
}}

with date_spine as (
    select
        dateadd(day, seq4(), '2016-01-01') as date_day
    from table(
        generator(rowcount => 5000)
    )

), date_enriched as (
    select
        to_number(to_char(date_day,'YYYYMMDD')) as date_key,
        date_day,

        year(date_day) as year,
        month(date_day) as month,
        to_char(date_day,'MMMM')                    as month_name,
        initcap(trim(to_char(date_day, 'DY')))     as day_name,

        day(date_day)                               as day_of_month,
        dayofweek(date_day)                         as day_of_week,
        week(date_day)                              as week_of_year,
        quarter(date_day)                           as quarter,

        case 
            when dayofweek(date_day) in (0,6) then true
            else false
        end as is_weekend

    from date_spine

)

select *
from date_enriched
