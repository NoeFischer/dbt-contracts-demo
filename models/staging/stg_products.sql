with source as (
    select * from {{ ref('raw_products') }}
),

renamed as (
    select
        cast(product_id as bigint) as product_id,
        cast(name as varchar) as name,
        cast(category as varchar) as category,
        cast(price as decimal(10, 2)) as price
    from source
)

select * from renamed
