{% macro limit_dev(filas) %}
    {% if target.name == 'dev' %}
        LIMIT {{ filas }}
    {% endif %}
{% endmacro %}