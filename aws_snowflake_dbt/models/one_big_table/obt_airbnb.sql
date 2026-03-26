{{ config(
    materialized='incremental',
    unique_key='booking_id',
    on_schema_change='sync_all_columns'
) }}

WITH bookings AS (
    SELECT * FROM {{ ref('fct_bookings') }}
    {% if is_incremental() %}
        where created_at > (SELECT MAX(created_at) FROM {{ this }})
    {% endif %}
),

listings as (select * from {{ ref('dim_listings') }}),
hosts    as (select * from {{ ref('dim_hosts') }}),
dates   as (select * from {{ ref('dim_date') }})

SELECT
    -- Keys
    b.BOOKING_ID,
    b.LISTING_ID,
    l.HOST_ID,
    b.DATE_ID,

    d.FULL_DATE AS BOOKING_DATE,

    --Booking Info
    b.BOOKING_STATUS,
    b.NIGHTS_BOOKED,
    b.BOOKING_AMOUNT,
    b.CLEANING_FEE,
    b.SERVICE_FEE,
    b.TOTAL_REVENUE,
    

    -- Listing Info
    l.PROPERTY_TYPE,
    l.ROOM_TYPE,
    l.CITY,
    l.COUNTRY,
    l.ACCOMMODATES,
    l.BEDROOMS,
    l.BATHROOMS,
    l.PRICE_PER_NIGHT,
    l.CAPACITY_TIER,
    l.BEDROOM_CATEGORY,
    l.PRICE_TIER,

    -- Host Info
    h.HOST_NAME,
    h.HOST_SINCE,
    h.IS_SUPERHOST,
    h.RESPONSE_RATE,
    h.HOST_TENURE_YEARS,
    h.HOST_TENURE_TIER,
    h.RESPONSE_TIER,

    d.DAY_OF_WEEK_NAME,
    d.MONTH_NUM,
    d.MONTH_NAME,
    d.QUARTER_NUM,
    d.QUARTER_NAME,
    d.YEAR_NUM,
    d.IS_WEEKEND,

    b.CREATED_AT

FROM bookings b

JOIN listings l 
ON b.LISTING_ID = l.LISTING_ID

JOIN hosts h 
ON l.HOST_ID = h.HOST_ID

JOIN dates d
ON b.DATE_ID = d.DATE_ID

