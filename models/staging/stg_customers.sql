with source as (
    select * from {{ ref('raw_customers') }}
),

renamed as (
    select
        cast(customer_id as bigint)  as customer_id,
        cast(name        as varchar) as name,
        cast(email       as varchar) as email,
        cast(country     as varchar) as country
    from source
)

select * from renamed
