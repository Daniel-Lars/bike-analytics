WITH source AS (

    SELECT *
    FROM {{ source('bike_data','bike_usage') }}
)
,

cleaned AS (

    SELECT
        usage_id,
        trim(bike_id) AS bike_id,
        {{ parse_date('usage_date') }} AS usage_date,
        distance_km
    FROM source

)
,

-- addressing data quality issues where usage_date is not available at source
filtered AS (

    SELECT *
    FROM cleaned
    WHERE usage_date IS NOT null
)

SELECT * FROM filtered
