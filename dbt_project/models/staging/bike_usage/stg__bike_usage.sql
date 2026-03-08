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

-- source data contain duplicated rows
-- rows are deduplicated in an arbitrary way using selecting the earliest usage date
-- in case usage dates differ
row_number AS (

    SELECT
        *,
        row_number() OVER (PARTITION BY usage_id ORDER BY usage_date ASC) AS rn
    FROM cleaned

)
,

deduplicated AS (

    SELECT *
    FROM row_number
    WHERE rn = 1
)
,

-- addressing data quality issues where usage_date is not available at source
-- excluding negative distance_km, to be clarified if DQ issue or valid business reason
filtered AS (

    SELECT *
    FROM deduplicated
    WHERE
        usage_date IS NOT null
        AND distance_km > 0
)

SELECT * FROM filtered
