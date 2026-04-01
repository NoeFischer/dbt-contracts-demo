with orders as (
    select * from {{ ref('stg_orders') }}
),

final as (
    select
        order_id,
        customer_id,
        product_id,
        amount,
        status,
        created_at as order_date
    from orders
)

select * from final
