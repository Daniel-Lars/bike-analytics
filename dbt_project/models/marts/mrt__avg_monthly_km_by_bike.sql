WITH bike_usage AS (

    SELECT *
    FROM {{ ref('fct__bike_usage') }}

)
,

monthly_aggregation_by_bike AS (

    SELECT
        bike_usage.bike_id,
        date_trunc('month', bike_usage.usage_date) AS usage_month,
        sum(bike_usage.distance_km) AS total_km_by_month
    FROM bike_usage
    GROUP BY bike_usage.bike_id, date_trunc('month', bike_usage.usage_date)

)
,

average_km_by_bike_per_month AS (

    SELECT
        bike_id,
        round(avg(total_km_by_month), 2) AS avg_km_by_month
    FROM monthly_aggregation_by_bike
    GROUP BY bike_id

)

SELECT *
FROM average_km_by_bike_per_month
