WITH bike_usage AS (

    SELECT *
    FROM {{ ref('fct__bike_usage') }}

)
,

dim_bike AS (
    SELECT *
    FROM {{ ref('dim__bike') }}
)
,

monthly_aggregation_by_bike AS (

    SELECT
        dim_bike.bike_id,
        date_trunc('month', bike_usage.usage_date) AS usage_month,
        sum(bike_usage.distance_km) AS total_km_by_month
    FROM bike_usage
    INNER JOIN dim_bike ON bike_usage.fk_bike_id = dim_bike.pk_bike
    GROUP BY dim_bike.bike_id, date_trunc('month', bike_usage.usage_date)

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
