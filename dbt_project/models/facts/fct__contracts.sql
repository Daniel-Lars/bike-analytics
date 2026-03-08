WITH base AS (

    SELECT
        contract_id AS fk_contract_id,
        customer_id AS fk_customer_id,
        bike_id AS fk_bike_id,
        contract_start_date,
        contract_end_date,
        monthly_rate
    FROM {{ ref('stg__contracts') }}
)

SELECT *
FROM base
