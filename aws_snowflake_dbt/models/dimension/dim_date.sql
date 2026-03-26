with dates AS (

    {{ dbt_utils.date_spine(
        datepart   = "day",
        start_date = "CAST('2020-01-01' AS DATE)",
        end_date   = "CAST('2030-12-31' AS DATE)"
    ) }}

),

final AS (

    SELECT
        -- surrogate key (integer format YYYYMMDD — eASy to join)
        CAST(TO_CHAR(DATE_DAY, 'YYYYMMDD') AS INTEGER) AS DATE_ID,

        -- bASe date
        DATE_DAY AS FULL_DATE,

        -- DAY-level attributes
        DAYOFWEEK(DATE_DAY) AS DAY_of_WEEK_num,    -- 0=Sun, 6=Sat
        DAYNAME(DATE_DAY) AS DAY_of_WEEK_name,   -- 'Monday'
        DAY(DATE_DAY) AS DAY_of_MONTH,

        -- WEEK
        WEEKOFYEAR(DATE_DAY) AS WEEK_of_YEAR,

        -- MONTH
        MONTH(DATE_DAY) AS MONTH_NUM,
        MONTHNAME(DATE_DAY) AS MONTH_NAME,  -- 'January'
        TO_CHAR(DATE_DAY, 'MON YYYY') AS MONTH_YEAR,  -- 'Jan 2024'

        -- QUARTER
        QUARTER(DATE_DAY) AS QUARTER_NUM,
        'Q' || QUARTER(DATE_DAY) AS QUARTER_name, -- 'Q1'
        'Q' || QUARTER(DATE_DAY) || ' ' || YEAR(DATE_DAY) AS QUARTER_YEAR,      -- 'Q1 2024'

        -- YEAR
        YEAR(DATE_DAY) AS YEAR_NUM,

        -- boolean flags
        CASE WHEN DAYOFWEEK(DATE_DAY) IN (0, 6)
             THEN TRUE 
             ELSE FALSE 
             END AS IS_WEEKEND,

        CASE WHEN DAYOFWEEK(DATE_DAY) NOT IN (0, 6)
             THEN TRUE 
             ELSE FALSE 
             END AS IS_WEEKDAY,

        -- fiscal YEAR (adjust offset to your company's fiscal start)
        CASE WHEN MONTH(DATE_DAY) >= 4
             THEN YEAR(DATE_DAY)
             ELSE YEAR(DATE_DAY) - 1 end  AS FISCAL_YEAR

    FROM dates

)

SELECT * FROM final
