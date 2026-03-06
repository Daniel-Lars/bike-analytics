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

SELECT * FROM cleaned
