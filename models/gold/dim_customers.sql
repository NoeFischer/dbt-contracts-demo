with customers as (
    select * from {{ ref('stg_customers') }}
)

select
    customer_id,
    name,
    email,
    country
from customers
