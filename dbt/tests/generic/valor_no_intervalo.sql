{% test valor_no_intervalo(model, column_name, min=none, max=none) %}

select {{ column_name }}
from {{ model }}
where false
{% if min is not none %} or {{ column_name }} < {{ min }} {% endif %}
{% if max is not none %} or {{ column_name }} > {{ max }} {% endif %}

{% endtest %}
