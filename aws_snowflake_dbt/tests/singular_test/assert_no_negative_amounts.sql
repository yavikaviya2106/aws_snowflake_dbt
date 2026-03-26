--Booking amount should not be in negative value
{% set columns = ['NIGHTS_BOOKED','BOOKING_AMOUNT','CLEANING_FEE','SERVICE_FEE'] %}

{%- for column in columns %}

    SELECT 
        booking_id
    FROM {{ref('fct_bookings')}}

    {{- column_never_be_negative(column)}} 

    {%- if not loop.last -%}
    UNION ALL
    {%- endif -%}

{%- endfor -%}


