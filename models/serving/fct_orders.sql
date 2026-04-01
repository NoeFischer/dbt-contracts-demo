-- Public interface. Resolves to the latest version via dbt model versioning.
select * from {{ ref('gold_fct_orders') }}
