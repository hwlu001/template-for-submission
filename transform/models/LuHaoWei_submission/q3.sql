{{
    config (
        materialized = 'view'
    )
}}
-- 3 - Find the top active vendor by GMV in each country

WITH TopVendor AS (
    SELECT 
        v.country_name, 
        v.vendor_name,
        ROUND(SUM(o.gmv_local),2) AS total_gmv,
        ROW_NUMBER() OVER(
          PARTITION BY v.country_name ORDER BY SUM(o.gmv_local) DESC) AS ranking
    FROM 
        {{ ref("vendors") }} v
    JOIN 
        {{ ref("orders") }} o ON v.id = o.vendor_id
    WHERE 
        v.is_active = TRUE
    GROUP BY 
        v.country_name, v.vendor_name
)
SELECT 
    country_name,
    vendor_name,
    total_gmv
FROM 
    TopVendor
WHERE 
    ranking = 1;
