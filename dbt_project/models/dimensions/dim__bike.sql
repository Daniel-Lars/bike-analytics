WITH base AS (

    SELECT DISTINCT bike_id
    FROM {{ ref('stg__bike_usage') }}
)

SELECT
    bike_id AS pk_bike,
    bike_id
FROM base
