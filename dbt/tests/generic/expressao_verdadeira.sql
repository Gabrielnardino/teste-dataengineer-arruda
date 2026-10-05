{% test expressao_verdadeira(model, expressao, column_name=none) %}

select *
from {{ model }}
where not ({{ expressao }})

{% endtest %}
