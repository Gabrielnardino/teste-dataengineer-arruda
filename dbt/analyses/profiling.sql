-- Evidências que justificam os tratamentos da silver. Rodar com `dbt compile` e executar no dw.

-- float4 na origem: 0.15 vira 0.15000000596 e a soma em float diverge da soma em numeric
select
    (0.15::real)::float8                                                    as desconto_em_double,
    sum(unit_price * quantity * (1 - discount))                             as liquido_float,
    sum(unit_price::numeric * quantity * (1 - discount::numeric))           as liquido_numeric
from {{ source('bronze', 'raw_order_details') }};

-- descontos fora da política de múltiplos de 5%
select discount, count(*)
from {{ source('bronze', 'raw_order_details') }}
group by 1
order by 1;

-- pedidos sem envio (todos no último mês = pendentes) e entregues com atraso
select
    count(*) filter (where shipped_date is null)                            as nao_enviados,
    min(order_date) filter (where shipped_date is null)                     as primeiro_nao_enviado,
    max(order_date)                                                         as ultimo_pedido,
    count(*) filter (where shipped_date > required_date)                    as atrasados
from {{ source('bronze', 'raw_orders') }};

-- preço do item difere do preço atual do produto (histórico de preço)
select count(*) as itens_com_preco_diferente
from {{ source('bronze', 'raw_order_details') }} d
join {{ source('bronze', 'raw_products') }} p using (product_id)
where d.unit_price <> p.unit_price;

-- região nula por país e cliente sem CEP
select country, count(*) as clientes, count(region) as com_regiao, count(postal_code) as com_cep
from {{ source('bronze', 'raw_customers') }}
group by 1
order by 1;

-- clientes sem pedido
select count(*) as clientes_sem_pedido
from {{ source('bronze', 'raw_customers') }} c
where not exists (select 1 from {{ source('bronze', 'raw_orders') }} o where o.customer_id = c.customer_id);

-- produto descontinuado com pedido de compra em aberto
select product_id, product_name, units_on_order
from {{ source('bronze', 'raw_products') }}
where discontinued = 1 and units_on_order > 0;
