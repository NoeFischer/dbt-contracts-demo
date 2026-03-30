with orders as (
    select * from {{ ref('stg_orders') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

final as (
    select
        o.order_id,
        o.customer_id,
        o.product_id,
        o.amount,
        o.status,
        o.created_at      as order_date,
        p.category        as product_category
    from orders o
    left join products p
        on o.product_id = p.product_id
)

select * from final
