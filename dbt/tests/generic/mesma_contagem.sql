{% test mesma_contagem(model, comparar_com) %}

select modelo.linhas as linhas_modelo, referencia.linhas as linhas_referencia
from (select count(*) as linhas from {{ model }}) as modelo
cross join (select count(*) as linhas from {{ comparar_com }}) as referencia
where modelo.linhas <> referencia.linhas

{% endtest %}
