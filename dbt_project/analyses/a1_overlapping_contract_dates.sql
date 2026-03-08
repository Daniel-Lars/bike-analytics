/*
Analysis showing the number of rows with overlapping contract dates
from the source data "contracts".
*/

WITH source AS (

    select
		*
    FROM {{source('bike_data','contracts')}}
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
lag_calc as (
	select
		*,
		lag(contract_start_date) over (partition by bike_id order by contract_start_date desc) as lag_date
	from end_date_null_replaced
)

,
overlapping_end_dates as (

	select
		*
	from lag_calc
	where lag_date < contract_end_date
	order by bike_id asc
)

select
	count(*)
from overlapping_end_dates
