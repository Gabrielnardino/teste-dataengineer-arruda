with periodo as (
    select min(data_pedido) as inicio, max(data_pedido) as fim
    from {{ ref('stg_pedidos') }}
),

calendario as (
    select min(data) as inicio, max(data) as fim, count(*) as dias
    from {{ ref('dm_calendario') }}
)

select *
from periodo
cross join calendario as c
where c.inicio <> periodo.inicio
   or c.fim <> periodo.fim
   or c.dias <> (periodo.fim - periodo.inicio + 1)
