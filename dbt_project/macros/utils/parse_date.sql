{% macro parse_date(column) %}

    {%- set format_to_regex = {
        'YYYY-MM-DD': '^\\d{4}-\\d{2}-\\d{2}$',
        'DD-MM-YYYY': '^\\d{2}-\\d{2}-\\d{4}$',
        'YYYY/MM/DD': '^\\d{4}/\\d{2}/\\d{2}$',
        'DD/MM/YYYY': '^\\d{2}/\\d{2}/\\d{4}$',
        'YYYY.MM.DD': '^\\d{4}\\.\\d{2}\\.\\d{2}$',
        'DD.MM.YYYY': '^\\d{2}\\.\\d{2}\\.\\d{4}$'
    } -%}

    CASE
    {% for format, regex in format_to_regex.items() -%}
        WHEN {{ column }} ~ '{{regex}}' THEN to_date( {{ column }}, '{{format}}' )
    {% endfor -%}
        ELSE NULL
    END

{% endmacro %}
