{{
    config (
        materialized = 'view'
    )
}}
-- 1 - Find the Total GMV by country

SELECT 
  orders.country_name, 
  ROUND(SUM(orders.gmv_local),2) AS total_gmv
FROM {{ ref("orders") }} as orders
GROUP BY orders.country_name;
