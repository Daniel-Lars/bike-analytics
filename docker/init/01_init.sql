create schema if not exists raw;

create table if not exists raw.contracts (

contract_id INT,
customer_id INT,
bike_id varchar,
start_date varchar,
end_date varchar,
monthly_rate numeric(10,2)

);

create table if not exists raw.customers (

customer_id INT,
name varchar,
city varchar,
signup_date varchar

);

create table if not exists raw.bike_usage (

usage_id INT,
bike_id varchar,
usage_date varchar,
distance_km numeric(10,2)

);

COPY raw.contracts
FROM '/data/contracts/contracts.csv'
DELIMITER ','
CSV HEADER;

COPY raw.customers
FROM '/data/customers/customers.csv'
DELIMITER ','
CSV HEADER;

COPY raw.bike_usage
FROM '/data/usage/bike_usage.csv'
DELIMITER ','
CSV HEADER;
