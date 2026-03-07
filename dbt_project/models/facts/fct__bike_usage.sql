SELECT
    usage_id,
    bike_id,
    usage_date,
    distance_km
FROM {{ ref('stg__bike_usage') }}
