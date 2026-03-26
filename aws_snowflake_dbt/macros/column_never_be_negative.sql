{% macro column_never_be_negative (column) %}

WHERE {{column}} < 0

{%endmacro%}