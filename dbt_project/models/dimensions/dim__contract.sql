WITH base AS (

    SELECT DISTINCT contract_id
    FROM {{ ref('stg__contracts') }}
)

SELECT
    contract_id AS pk_contract,
    contract_id
FROM base
