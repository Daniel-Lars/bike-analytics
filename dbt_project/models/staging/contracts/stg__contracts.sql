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
,
end_date_null_replaced AS (

    SELECT
        contract_id,
        customer_id,
        bike_id,
        contract_start_date,
        coalesce(contract_end_date, {{ var('end_of_time') }}) AS contract_end_date,
        monthly_rate
    FROM cleaned
)
,

overlapping_contract_end_dates AS (

    SELECT
        *,
        lag(contract_start_date)
            OVER (PARTITION BY bike_id ORDER BY contract_start_date DESC)
            AS succession_contract_start_date
    FROM end_date_null_replaced

)
,

contract_timeline_wo_overlap AS (

    SELECT
        contract_id,
        customer_id,
        bike_id,
        contract_start_date,
        CASE
            WHEN
                succession_contract_start_date < contract_end_date
                THEN cast((succession_contract_start_date - interval '1 day') AS date)
            ELSE contract_end_date
        END AS contract_end_date,
        monthly_rate
    FROM overlapping_contract_end_dates
)

SELECT * FROM contract_timeline_wo_overlap
