-- Public interface. To cut over to a new version, update the ref() here.
select * from {{ ref('gold_fct_orders_v2') }}
