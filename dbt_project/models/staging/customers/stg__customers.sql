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

SELECT * FROM cleaned
