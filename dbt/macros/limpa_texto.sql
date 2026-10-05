{% macro limpa_texto(coluna) -%}
    nullif(trim({{ coluna }}), '')
{%- endmacro %}
