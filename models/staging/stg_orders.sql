with source as (
    select * from {{ ref('raw_orders') }}
),

renamed as (
    select
        cast(order_id    as bigint)         as order_id,
        cast(customer_id as bigint)         as customer_id,
        cast(product_id  as bigint)         as product_id,
        cast(amount      as decimal(10, 2)) as amount,
        cast(status      as varchar)        as status,
        cast(created_at  as date)           as created_at
    from source
)

select * from renamed
