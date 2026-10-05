select
    cliente_id,
    nome_empresa,
    nome_contato,
    cargo_contato,
    endereco,
    cidade,
    coalesce(regiao, 'Não informado')::varchar(15) as regiao,
    coalesce(cep, 'Não informado')::varchar(15)    as cep,
    pais,
    telefone
from {{ ref('stg_clientes') }}
