select
    {{ limpa_texto('customer_id') }}::varchar(5)    as cliente_id,
    {{ limpa_texto('company_name') }}::varchar(40)  as nome_empresa,
    {{ limpa_texto('contact_name') }}::varchar(30)  as nome_contato,
    {{ limpa_texto('contact_title') }}::varchar(30) as cargo_contato,
    {{ limpa_texto('address') }}::varchar(60)       as endereco,
    {{ limpa_texto('city') }}::varchar(15)          as cidade,
    {{ limpa_texto('region') }}::varchar(15)        as regiao,
    {{ limpa_texto('postal_code') }}::varchar(10)   as cep,
    {{ limpa_texto('country') }}::varchar(15)       as pais,
    {{ limpa_texto('phone') }}::varchar(24)         as telefone,
    {{ limpa_texto('fax') }}::varchar(24)           as fax
from {{ source('bronze', 'raw_customers') }}
