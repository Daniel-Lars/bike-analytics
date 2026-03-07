WITH source AS (

    SELECT *
    FROM {{ source('bike_data','customers') }}
)
,

cleaned AS (

    SELECT
        customer_id,
        trim(name) AS customer_name,
        trim(city) AS city,
        {{ parse_date('signup_date') }} AS signup_date
    FROM source

)
,

-- addressing data quality issues where sigup_date is not available at source
filtered AS (

    SELECT *
    FROM cleaned
    WHERE signup_date IS NOT null
)

SELECT * FROM filtered
