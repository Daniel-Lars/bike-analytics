WITH dates AS (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2021-01-01' as date)",
        end_date="cast('2030-12-31' as date)"
    ) }})

SELECT
    cast(date_day AS date) AS pk_date_key,
    cast(date_day AS date) AS calendar_date,
    cast(extract(YEAR FROM date_day) AS int) AS calendar_year,
    cast(extract(MONTH FROM date_day) AS int) AS calendar_month,
    cast(extract(DAY FROM date_day) AS int) AS day_of_month,
    cast(extract(WEEK FROM date_day) AS int) AS week_of_year,
    cast(extract(QUARTER FROM date_day) AS int) AS calendar_quarter
FROM dates
