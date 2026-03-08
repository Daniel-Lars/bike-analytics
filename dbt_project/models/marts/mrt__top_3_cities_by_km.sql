WITH bike_usage AS (

    SELECT *
    FROM {{ ref('fct__bike_usage') }}
)
,

customer AS (

    SELECT *
    FROM {{ ref('dim__customer') }}
)
,

total_km_by_city AS (

    SELECT
        customer.city,
        sum(bike_usage.distance_km) AS total_km
    FROM bike_usage
    INNER JOIN customer ON bike_usage.fk_customer_id = customer.pk_customer
    GROUP BY customer.city
)

SELECT *
FROM total_km_by_city
ORDER BY total_km DESC
LIMIT 3
