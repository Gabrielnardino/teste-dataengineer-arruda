select
    produto_id,
    nome_produto,
    categoria_id,
    fornecedor_id,
    quantidade_por_unidade,
    preco_unitario as preco_unitario_atual,
    descontinuado
from {{ ref('stg_produtos') }}
