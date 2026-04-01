-- Public interface — consumers always query this view, never the versioned tables directly.
-- To cut over to a new version, update the ref() here.
select * from {{ ref('fct_orders_v2') }}
