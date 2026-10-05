select
    order_id::integer                             as pedido_id,
    product_id::integer                           as produto_id,
    round(unit_price::numeric, 2)::numeric(10,2)  as preco_unitario,
    quantity::integer                             as quantidade,
    round(discount::numeric, 2)::numeric(4,2)     as desconto
from {{ source('bronze', 'raw_order_details') }}
