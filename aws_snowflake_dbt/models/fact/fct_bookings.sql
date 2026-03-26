{{ config(materialized='incremental',
          unique_key='booking_id',
          on_schema_change='sync_all_columns') }}


WITH source AS (
    SELECT * FROM {{ref('stg_bookings')}}
    {% if is_incremental() %}
        WHERE created_at > (SELECT MAX(created_at) FROM {{ this }})
    {% endif %}

),

final AS(

SELECT
BOOKING_ID,
LISTING_ID,
CAST(TO_CHAR(BOOKING_DATE,'YYYYMMDD') AS INTEGER) AS DATE_ID,

NIGHTS_BOOKED,
BOOKING_AMOUNT,
CLEANING_FEE,
SERVICE_FEE,
UPPER(BOOKING_STATUS) AS BOOKING_STATUS,
(BOOKING_AMOUNT + CLEANING_FEE + SERVICE_FEE)  AS TOTAL_REVENUE,
CREATED_AT

FROM source
ORDER BY BOOKING_DATE
)

SELECT * FROM final