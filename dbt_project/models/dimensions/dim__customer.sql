WITH base AS (

    SELECT DISTINCT
        customer_id,
        customer_name,
        city,
        signup_date
    FROM {{ ref('stg__customers') }}

)

SELECT
    customer_id AS pk_customer,
    customer_id,
    customer_name,
    city,
    signup_date
FROM base
