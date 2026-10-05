select
    order_id::integer                                  as pedido_id,
    {{ limpa_texto('customer_id') }}::varchar(5)       as cliente_id,
    employee_id::integer                               as funcionario_id,
    ship_via::integer                                  as transportadora_id,
    order_date                                         as data_pedido,
    required_date                                      as data_limite_entrega,
    shipped_date                                       as data_envio,
    round(freight::numeric, 2)::numeric(10,2)          as valor_frete,
    {{ limpa_texto('ship_name') }}::varchar(40)        as nome_destinatario,
    {{ limpa_texto('ship_address') }}::varchar(60)     as endereco_entrega,
    {{ limpa_texto('ship_city') }}::varchar(15)        as cidade_entrega,
    {{ limpa_texto('ship_region') }}::varchar(15)      as regiao_entrega,
    {{ limpa_texto('ship_postal_code') }}::varchar(10) as cep_entrega,
    {{ limpa_texto('ship_country') }}::varchar(15)     as pais_entrega,
    shipped_date is not null                           as pedido_enviado,
    coalesce(shipped_date > required_date, false)      as entregue_com_atraso
from {{ source('bronze', 'raw_orders') }}
