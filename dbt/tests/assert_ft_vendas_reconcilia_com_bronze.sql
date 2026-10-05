with bronze as (
    select
        count(*)                                                        as linhas,
        sum(quantity)                                                   as quantidade,
        sum(unit_price::numeric * quantity)                             as valor_bruto,
        sum(unit_price::numeric * quantity * (1 - discount::numeric))   as valor_liquido
    from {{ source('bronze', 'raw_order_details') }}
),

gold as (
    select
        count(*)            as linhas,
        sum(quantidade)     as quantidade,
        sum(valor_bruto)    as valor_bruto,
        sum(valor_liquido)  as valor_liquido
    from {{ ref('ft_vendas') }}
)

select *
from bronze
cross join gold as g
where bronze.linhas <> g.linhas
   or bronze.quantidade <> g.quantidade
   or bronze.valor_bruto <> g.valor_bruto
   or bronze.valor_liquido <> g.valor_liquido
