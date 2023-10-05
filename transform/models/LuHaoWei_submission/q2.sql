{{
    config (
        materialized = 'view'
    )
}}
-- 2 - Calculate the GMV of vendors in Taiwan and order the result their customer count

SELECT 
    v.vendor_name,
    COUNT(DISTINCT o.customer_id) AS customer_count,
    SUM(o.gmv_local) AS total_gmv
FROM 
    {{ ref("vendors") }} v
JOIN 
    {{ ref("orders") }} o ON v.id = o.vendor_id
WHERE
    v.country_name = 'Taiwan'
GROUP BY 
    v.vendor_name
ORDER BY
    customer_count DESC;
    