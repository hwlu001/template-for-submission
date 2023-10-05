{{
    config (
        materialized = 'view'
    )
}}
-- PART E - Write a query

SELECT q.country_name
FROM {{ ref("q1") }} as q;