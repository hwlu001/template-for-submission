{{
    config (
        materialized = 'view'
    )
}}
-- 4 - Find the top 2 vendors per country, in each year available in the dataset

SELECT 
  DATETIME_TRUNC(year, YEAR)
  country_name,
  vendor_name,
  total_gmv
FROM (
  SELECT
  o.date_local as year,
  v.country_name,
  v.vendor_name,
  ROUND(SUM(o.gmv_local),2) AS total_gmv,
  ROW_NUMBER() OVER(
    PARTITION BY o.date_local, v.country_name
    ORDER BY SUM(o.gmv_local) DESC) as ranking
  FROM 
    {{ ref("orders") }} o
  INNER JOIN 
    {{ ref("vendors") }} v ON o.vendor_id = v.id
  GROUP BY 
    o.date_local,v.vendor_name,v.country_name
  ORDER BY 
    o.date_local,v.country_name
)
WHERE 
  ranking <=2
