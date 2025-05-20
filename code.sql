use role accountadmin;

-- Remove default objects
drop warehouse compute_wh;
drop database snowflake_sample_data;

-- Set account parameters
alter account set
timezone = 'Australia/Melbourne' -- Set to your local timezone
timestamp_type_mapping = timestamp_ltz -- Timestamps use the local timezone
week_start = 1; -- Sets the start of the week to Monday

use role useradmin;

-- Example of creating a user
/*
create user joel_harris
password = 'password123'
must_change_password = true
type = person;
*/

use role sysadmin;

-- Create databases
create database dev;
create database prod;

-- Create dev data layers
create schema dev.landing;
create schema dev.raw;
create schema dev.refined;
create schema dev.presentation;

-- Create prod data layers
create schema prod.landing;
create schema prod.raw;
create schema prod.refined;
create schema prod.presentation;

use role sysadmin;

create warehouse ingest_wh
warehouse_size = xsmall
auto_suspend = 60
initially_suspended = true;

create warehouse transform_wh
warehouse_size = medium
auto_suspend = 60
initially_suspended = true;

create warehouse present_wh
warehouse_size = small
auto_suspend = 60
initially_suspended = true;

create warehouse developer_wh
warehouse_size = xsmall
auto_suspend = 60
initially_suspended = true;

create warehouse admin_wh
warehouse_size = xsmall
auto_suspend = 60
initially_suspended = true;

use role securityadmin;

-- Create functional roles
create role developer;
create role analyst;
create role admin;

-- Create access roles
create role read_dev;
create role write_dev;

create role read_prod;
create role write_prod;

-- Grant privileges to access roles
grant usage on database dev to role read_dev;
grant usage on all schemas in database dev to role read_dev;
grant select on all tables in database dev to role read_dev;
grant select on all views in database dev to role read_dev;

grant all on database dev to role write_dev;
grant all on all schemas in database dev to role write_dev;

grant usage on database prod to role read_prod;
grant usage on all schemas in database prod to role read_prod;
grant select on all tables in database prod to role read_prod;
grant select on all views in database prod to role read_prod;

grant all on database prod to role write_prod;
grant all on all schemas in database prod to role write_prod;

-- Grant access roles to functional roles
grant role read_dev to role analyst;
grant role read_prod to role analyst;

grant role write_dev to role developer;
grant role read_prod to role developer;

grant role write_dev to role admin;
grant role write_prod to role admin;

-- Grant compute resources to functional roles
grant usage, monitor on warehouse developer_wh to role developer;
grant usage, monitor on warehouse present_wh to role analyst;
grant usage, monitor on warehouse admin_wh to role admin;

-- Example of granting to a user
/*
grant role admin to user joel_harris;
*/