WITH contracts AS (

    SELECT
        fk_contract,
        contract_start_date,
        cast(coalesce(contract_end_date, '9999-12-31') AS date) AS contract_end_date
    FROM {{ ref('fct__contracts') }}
)
,

calendar AS (
    SELECT *
    FROM {{ ref('dim__calendar') }}
    WHERE
        day_of_month = 1
        AND pk_date_key <= now()

)
,

joined AS (

    SELECT
        calendar.calendar_year,
        calendar.calendar_month,
        contracts.fk_contract
    FROM calendar
    LEFT JOIN contracts
        ON
            date_trunc('month', contracts.contract_start_date) <= calendar.pk_date_key
            AND date_trunc('month', contracts.contract_end_date) >= calendar.pk_date_key
)
,
aggregated AS (
    SELECT
        calendar_year,
        calendar_month,
        count(*) AS active_contracts
    FROM joined
    WHERE fk_contract IS NOT null
    GROUP BY calendar_year, calendar_month

)

SELECT *
FROM aggregated
