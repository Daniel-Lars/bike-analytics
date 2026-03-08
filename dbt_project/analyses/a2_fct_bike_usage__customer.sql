/*
Analysis showing the number of customer ids in the bike usage fact table
that do not have a respective counterpart in dim__customer.
*/

WITH fct_bike_usage AS (

    select
		*
    FROM {{ref('fct__bike_usage')}}
    )

,

customer as (

    select *
    FROM {{ref('dim__customer')}}
)


select
	count(*)
from fct_bike_usage
left join customer on customer.pk_customer = fct_bike_usage.fk_customer_id
where customer.pk_customer is null
