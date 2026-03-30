-- ref('fct_orders') resolves to latest_version: 2
select * from {{ ref('fct_orders') }}
limit 5;

-- Explicitly pin to v1 (no product_category column)
select * from {{ ref('fct_orders', version=1) }}
limit 5;

-- v2 has product_category; v1 does not
select order_id, product_category
from {{ ref('fct_orders', version=2) }}
limit 5;

-- Join dim_customers to fct_orders (v2)
select
    c.name,
    c.country,
    o.amount,
    o.product_category
from {{ ref('fct_orders') }}    o
join {{ ref('dim_customers') }} c
    on o.customer_id = c.customer_id
order by o.amount desc
limit 10;
