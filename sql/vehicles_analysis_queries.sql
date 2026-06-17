/* ============================================================
   VEHICLES ANALYSIS
   Dataset: vehicles_analysis
   Description: Analysis of used car listings to identify
                key price drivers and market trends
   ============================================================ */


/* ============================================================
   SECTION 1: DATA OVERVIEW
   Purpose:
   - Understand dataset size and general characteristics
   - Establish baseline metrics
   ============================================================ */

-- Total number of listings

SELECT COUNT(*) AS total_listings
FROM vehicles_analysis;

-- Average price

SELECT AVG(price) AS avg_price
FROM vehicles_analysis;

-- Median price

SELECT DISTINCT 
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) OVER() AS median_price
FROM vehicles_analysis;

-- Price range (min/max)

SELECT 
MIN(price) AS minimum_price,
MAX(price) AS maximum_price
FROM vehicles_analysis;

-- Year range (min/max)

SELECT 
MIN(year) AS minimum_year,
MAX(year) AS maximum_year
FROM vehicles_analysis;

-- Odometer range (min/max)

SELECT 
MIN(odometer) AS minimum_odometer,
MAX(odometer) AS maximum_odometer
FROM vehicles_analysis;


/* ============================================================
   SECTION 2: PRICE VS YEAR (DEPRECIATION)
   Purpose:
   - Analyze how vehicle age impacts price
   - Identify depreciation trends
   ============================================================ */

-- Listing count by year

SELECT
year,
COUNT(*) AS listing_count
FROM vehicles_analysis
GROUP BY year
ORDER BY year;

-- Average price by year

SELECT
year,
AVG(price) average_price
FROM vehicles_analysis
GROUP BY year
ORDER BY year;

-- Median price by year

SELECT DISTINCT
year,
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) OVER (PARTITION BY year) AS median_price
FROM vehicles_analysis
ORDER BY year;

-- Average price by decade
SELECT
decade,
AVG(price) AS average_price
FROM (
    SELECT
    price,
    year,
    CASE WHEN year BETWEEN 2000 AND 2009 THEN '2000s'
         WHEN year BETWEEN 2010 AND 2019 THEN '2010s'
         WHEN year BETWEEN 2020 AND 2029 THEN '2020s'
         ELSE 'other'
    END AS decade
    FROM vehicles_analysis
)t
GROUP BY decade
ORDER BY decade;


/* ============================================================
   SECTION 3: PRICE VS MILEAGE
   Purpose:
   - Analyze how mileage affects price
   - Identify value drop-off patterns
   ============================================================ */

-- Average price by mileage

SELECT
odometer,
AVG(price) AS average_price
FROM vehicles_analysis
GROUP BY odometer
ORDER BY odometer;

-- Mileage grouped into buckets

SELECT
mileage_range,
AVG(price) AS average_price,
COUNT(*) AS listing_count
FROM (
    SELECT
    odometer,
    price,
    CASE WHEN odometer < 30000 THEN 'Less than 30k'
         WHEN odometer BETWEEN 30000 AND 59999 THEN '30k-60k'
         WHEN odometer BETWEEN 60000 AND 89999 THEN '60k-90k'
         WHEN odometer BETWEEN 90000 AND 119999 THEN '90k-120k'
         WHEN odometer BETWEEN 120000 AND 149999 THEN '120k-150k'
         WHEN odometer BETWEEN 150000 AND 199999 THEN '150k-200k'
         ELSE '200k+'
    END AS mileage_range,
    CASE WHEN odometer < 30000 THEN 1
         WHEN odometer BETWEEN 30000 AND 59999 THEN 2
         WHEN odometer BETWEEN 60000 AND 89999 THEN 3
         WHEN odometer BETWEEN 90000 AND 119999 THEN 4
         WHEN odometer BETWEEN 120000 AND 149999 THEN 5
         WHEN odometer BETWEEN 150000 AND 199999 THEN 6
         ELSE 7
    END AS sort_order
    FROM vehicles_analysis
)t
GROUP BY mileage_range, sort_order
ORDER BY sort_order;


/* ============================================================
   SECTION 4: MANUFACTURER ANALYSIS
   Purpose:
   - Compare pricing across brands
   - Identify brands that retain value
   ============================================================ */

-- Average price by manufacturer

SELECT
manufacturer,
AVG(price) AS average_price
FROM vehicles_analysis
GROUP BY manufacturer
HAVING COUNT(*) >= 100
ORDER BY AVG(price) DESC;

-- Median price by manufacturer

SELECT DISTINCT
manufacturer,
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) OVER (PARTITION BY manufacturer) AS median_price
FROM vehicles_analysis
ORDER BY median_price DESC;

-- Top manufacturers by listing count

SELECT
manufacturer,
COUNT(*) AS listing_count
FROM vehicles_analysis
GROUP BY manufacturer
ORDER BY COUNT(*) DESC;

-- Filter to top 10 manufacturers

SELECT TOP 10
manufacturer,
COUNT(*) AS listing_count
FROM vehicles_analysis
GROUP BY manufacturer
ORDER BY COUNT(*) DESC;


/* ============================================================
   SECTION 5: VEHICLE TYPE & FEATURES
   Purpose:
   - Analyze how features impact price
   ============================================================ */

-- Average price by vehicle type

SELECT
type,
AVG(price) AS average_price,
COUNT(*) AS listing_count
FROM vehicles_analysis
WHERE type IS NOT NULL
GROUP BY type
ORDER BY average_price DESC;

-- Average price by fuel type

SELECT
fuel,
AVG(price) AS average_price,
COUNT(*) AS listing_count
FROM vehicles_analysis
WHERE fuel IS NOT NULL
GROUP BY fuel
ORDER BY average_price DESC;

-- Average price by transmission

SELECT
transmission,
AVG(price) AS average_price,
COUNT(*) AS listing_count
FROM vehicles_analysis
WHERE transmission IS NOT NULL
GROUP BY transmission
ORDER BY average_price DESC;

-- Average price by drive type (AWD/FWD/RWD)

SELECT
drive,
AVG(price) AS average_price,
COUNT(*) AS listing_count
FROM vehicles_analysis
WHERE drive IS NOT NULL
GROUP BY drive
ORDER BY average_price DESC;

-- Condition vs price

SELECT
condition,
AVG(price) AS average_price,
COUNT(*) AS listing_count
FROM vehicles_analysis
WHERE condition IS NOT NULL
GROUP BY condition
ORDER BY average_price DESC;


/* ============================================================
   SECTION 6: GEOGRAPHIC ANALYSIS
   Purpose:
   - Identify regional pricing differences
   ============================================================ */

-- Average price by state

SELECT
state,
AVG(price) AS average_price
FROM vehicles_analysis
GROUP BY state
ORDER BY AVG(price) DESC;

-- Listing count by state

SELECT
state,
COUNT(*) AS number_of_listings
FROM vehicles_analysis
GROUP BY state
ORDER BY COUNT(*) DESC;


/* ============================================================
   SECTION 7: ADVANCED ANALYSIS
   Purpose:
   - Deeper insights and custom exploration
   ============================================================ */

-- Price normalized by age

SELECT
year,
manufacturer,
model,
odometer,
price,
YEAR(posting_date) - year AS age,
(price * 1.0) / NULLIF(YEAR(posting_date) - year, 0) AS price_per_year
FROM vehicles_analysis
ORDER BY price_per_year DESC

-- Mileage vs year interaction

SELECT
year,
manufacturer,
model,
odometer,
price,
YEAR(posting_date) - year AS age,
odometer * 1.0 / NULLIF(YEAR(posting_date) - year, 0) AS miles_per_year
FROM vehicles_analysis
ORDER BY miles_per_year DESC

-- Best value vehicles
WITH cleaned AS (
    SELECT
    *
    FROM vehicles_analysis
    WHERE
    year < 2021
    AND price BETWEEN 100 and 200000
    AND odometer BETWEEN 0 AND 150000
),
bounded AS (
    SELECT
    *
    FROM (
        SELECT
        *,
        PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY price) OVER () AS price_p5,
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY price) OVER () AS price_p95,
        PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY odometer) OVER () AS odo_p5,
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY odometer) OVER () AS odo_p95
        FROM cleaned
    )t
    WHERE price BETWEEN price_p5 AND price_p95
    AND odometer BETWEEN odo_p5 AND odo_p95
),
value_filtered AS (
    SELECT
    *,
    (price * 1.0) / NULLIF(YEAR(posting_date) - year, 0) AS price_per_year,
    (price * 1.0) / NULLIF(odometer, 0) AS price_per_mile
    FROM bounded
    WHERE (price * 1.0) / NULLIF(YEAR(posting_date) - year, 0) BETWEEN 500 AND 10000
)
SELECT
year,
manufacturer,
model,
odometer,
price
FROM value_filtered
ORDER BY price_per_year, price_per_mile

/* Limitations:
   - Value is defined purely based on price relative to age and mileage
   - Does not account for manufacturer reliability, vehicle condition, or trim level
   - Assumes lower price per year and per mile indicates better value, which may not reflect long-term ownership costs
*/


/* ============================================================
   NOTES / OBSERVATIONS
   Purpose:
   - Capture key patterns, anomalies, and exploratory insights
   - Document findings discovered during SQL analysis
   ============================================================ */

-- Price & Depreciation:
-- - Strong negative relationship between vehicle age and price
-- - Depreciation appears steepest within the first 5–7 years

-- Mileage Trends:
-- - Mileage negatively impacts price, though the effect appears to weaken at higher mileage levels
-- - Certain manufacturers show higher median mileage, possibly due to survivorship bias

-- Manufacturer Insights:
-- - Luxury brands dominate the highest price ranges
-- - Domestic brands account for the majority of listings
