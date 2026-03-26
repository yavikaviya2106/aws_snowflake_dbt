{{ config(severity='warn') }}

SELECT b.LISTING_ID

FROM {{ ref('stg_bookings') }} b

LEFT JOIN {{ ref('stg_listings') }} l 
ON b.LISTING_ID = l.LISTING_ID

WHERE l.LISTING_ID IS NULL