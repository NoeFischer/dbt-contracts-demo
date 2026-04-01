{{ config(alias='fct_orders') }}
-- Public interface. To cut over to a new version, update version= here.
select * from {{ ref('fct_orders', version=2) }}
