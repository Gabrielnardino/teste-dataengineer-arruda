with itens as (
    select
        i.pedido_id,
        i.produto_id,
        p.cliente_id,
        p.data_pedido,
        i.quantidade,
        i.preco_unitario,
        (i.preco_unitario * i.quantidade)::numeric(12,2)              as valor_bruto,
        (i.preco_unitario * i.quantidade * i.desconto)::numeric(14,4) as valor_desconto
    from {{ ref('stg_itens_pedido') }} as i
    inner join {{ ref('stg_pedidos') }} as p on p.pedido_id = i.pedido_id
)

select
    pedido_id,
    produto_id,
    cliente_id,
    data_pedido,
    quantidade,
    preco_unitario,
    valor_bruto,
    valor_desconto,
    (valor_bruto - valor_desconto)::numeric(14,4) as valor_liquido
from itens
