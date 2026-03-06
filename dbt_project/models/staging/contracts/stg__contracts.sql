WITH source AS (

    SELECT *
    FROM {{ source('bike_data','contracts') }}
)
,

cleaned AS (

    SELECT
        contract_id,
        customer_id,
        trim(bike_id) AS bike_id,
        {{ parse_date('start_date') }} AS contract_start_date,
        {{ parse_date('end_date') }} AS contract_end_date,
        monthly_rate
    FROM source

)

SELECT * FROM cleaned
