select
    product_id::integer                                 as produto_id,
    {{ limpa_texto('product_name') }}::varchar(40)      as nome_produto,
    supplier_id::integer                                as fornecedor_id,
    category_id::integer                                as categoria_id,
    {{ limpa_texto('quantity_per_unit') }}::varchar(20) as quantidade_por_unidade,
    round(unit_price::numeric, 2)::numeric(10,2)        as preco_unitario,
    units_in_stock::integer                             as unidades_em_estoque,
    units_on_order::integer                             as unidades_em_pedido,
    reorder_level::integer                              as nivel_reposicao,
    discontinued = 1                                    as descontinuado
from {{ source('bronze', 'raw_products') }}
