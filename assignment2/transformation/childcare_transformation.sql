
CREATE TABLE IF NOT EXISTS `nyc-childcare-inspections.childcare_data.childcare_transformed` AS
SELECT
    *,

    -- date 
    DATE(inspectiondate) AS inspection_date_clean,

    -- Split and seperate date 
    EXTRACT(YEAR FROM DATE(inspectiondate)) AS inspection_year,
    EXTRACT(QUARTER FROM DATE(inspectiondate)) AS inspection_quarter,
    EXTRACT(MONTH FROM DATE(inspectiondate)) AS inspection_month,
    EXTRACT(DAY FROM DATE(inspectiondate)) AS inspection_day,
    EXTRACT(DAYOFWEEK FROM DATE(inspectiondate)) AS inspection_dayofweek,
    EXTRACT(WEEK FROM DATE(inspectiondate)) AS inspection_week,
    EXTRACT(HOUR FROM TIMESTAMP(inspectiondate)) AS inspection_hour,

    -- data types
    CAST(zipcode AS STRING) AS zipcode_clean,
    CAST(totaleducationalworkers AS INT64) AS totaleducationalworkers_clean,
    CAST(violationratepercent AS FLOAT64) AS violationratepercent_clean,

    -- new columns
    CASE WHEN violationcategory = 'Public Health Hazard' THEN 1 ELSE 0 END
        AS critical_violation_flag,

    CONCAT(building, ' ', street, ', ', borough, ', NY ', zipcode) AS full_address,

    -- summing
    (violationratepercent + publichealthhazardviolationrate) AS combined_violation_score

FROM
    `nyc-childcare-inspections.childcare_data.raw_childcare_inspections`

WHERE zipcode IS NOT NULL
  AND borough IN ('QUEENS','BROOKLYN','BRONX','MANHATTAN','STATEN ISLAND')

QUALIFY ROW_NUMBER() OVER (
    PARTITION BY centername, DATE(inspectiondate)
    ORDER BY inspectiondate DESC
) = 1;
