-- ============================================================
-- fct_orders_broken.sql
--
-- This model intentionally VIOLATES its data contract.
--
-- The contract declares:  order_id  bigint  not null
-- This model returns:     id        bigint         (wrong column name!)
--
-- Run:  dbt run --select fct_orders_broken
-- Expected outcome: CONTRACT ENFORCEMENT ERROR
-- ============================================================

with orders as (
    select * from {{ ref('stg_orders') }}
),

products as (
    select * from {{ ref('stg_products') }}
)

select
    o.order_id as id,              -- ❌ renamed: contract expects 'order_id'
    o.customer_id,
    o.product_id,
    o.amount,
    o.status,
    o.created_at as order_date,
    p.category as product_category
from orders as o
left join products as p on o.product_id = p.product_id
