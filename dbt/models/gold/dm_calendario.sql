with dias as (
    select generate_series(min(data_pedido), max(data_pedido), interval '1 day')::date as data
    from {{ ref('stg_pedidos') }}
)

select
    data,
    extract(year from data)::integer                                    as ano,
    extract(quarter from data)::integer                                 as trimestre,
    extract(month from data)::integer                                   as mes,
    (array['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho',
           'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'])
        [extract(month from data)]::varchar(9)                          as nome_mes,
    extract(isodow from data)::integer                                  as dia_semana,
    (array['Segunda-feira', 'Terça-feira', 'Quarta-feira', 'Quinta-feira',
           'Sexta-feira', 'Sábado', 'Domingo'])
        [extract(isodow from data)]::varchar(13)                        as nome_dia_semana,
    extract(isodow from data) in (6, 7)                                 as fim_de_semana
from dias
