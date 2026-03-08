WITH bike_usage AS (

    SELECT *
    FROM {{ ref('stg__bike_usage') }}
)
,

contracts AS (

    SELECT *
    FROM {{ ref('stg__contracts') }}
)
,

bike_usage_enriched AS (

    SELECT
        bike_usage.usage_id AS pk_bike_usage_id,
        bike_usage.usage_id AS bike_usage_id,
        bike_usage.bike_id AS fk_bike_id,
        contracts.customer_id AS fk_customer_id,
        bike_usage.usage_date,
        bike_usage.distance_km
    FROM bike_usage
    LEFT JOIN contracts
        ON
            bike_usage.bike_id = contracts.bike_id
            AND bike_usage.usage_date >= contracts.contract_start_date
            AND bike_usage.usage_date <= contracts.contract_end_date

)

SELECT *
FROM bike_usage_enriched
