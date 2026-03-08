/*
Analysis showing the number of customer ids in the fct_contract table
that do not have a respective counterpart in dim__customer.
*/

WITH fct_contracts AS (

    select
		*
    FROM {{ref('fct__contracts')}}
    )

,

customer as (

    select *
    FROM {{ref('dim__customer')}}
)


select
	count(*)
from fct_contracts
left join customer on customer.pk_customer = fct_contracts.fk_customer_id
where customer.pk_customer is null
