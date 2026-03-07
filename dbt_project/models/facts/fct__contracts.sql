WITH base AS (

    SELECT
        contract_id AS fk_contract,
        customer_id AS fk_customer,
        bike_id AS fk_bike,
        contract_start_date,
        contract_end_date,
        monthly_rate
    FROM {{ ref('stg__contracts') }}
)

SELECT *
FROM base
