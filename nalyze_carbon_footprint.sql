WITH industry_totals AS (
    SELECT 
        industry_group,
        SUM(carbon_footprint_pcf) AS total_carbon_footprint
    FROM carbon_emissions
    GROUP BY industry_group
),
total_footprint AS (
    SELECT SUM(carbon_footprint_pcf) AS global_total
    FROM carbon_emissions
),
ranked_products AS (
    SELECT 
        industry_group,
        product_name,
        carbon_footprint_pcf,
        ROW_NUMBER() OVER (PARTITION BY industry_group ORDER BY carbon_footprint_pcf DESC) AS rank
    FROM carbon_emissions
),
industry_averages AS (
    SELECT 
        industry_group,
        ROUND(AVG(CAST(upstream_percent_total_pcf AS FLOAT)), 2) AS avg_upstream,
        ROUND(AVG(CAST(operations_percent_total_pcf AS FLOAT)), 2) AS avg_operations,
        ROUND(AVG(CAST(downstream_percent_total_pcf AS FLOAT)), 2) AS avg_downstream
    FROM carbon_emissions
    GROUP BY industry_group
)
SELECT 
    i.industry_group,
    i.total_carbon_footprint,
    ROUND((i.total_carbon_footprint / t.global_total) * 100, 2) AS percent_contribution,
    r.product_name AS top_product,
    r.carbon_footprint_pcf AS top_product_footprint,
    a.avg_upstream,
    a.avg_operations,
    a.avg_downstream
FROM industry_totals i
JOIN total_footprint t ON 1=1
LEFT JOIN ranked_products r ON i.industry_group = r.industry_group AND r.rank = 1
JOIN industry_averages a ON i.industry_group = a.industry_group
ORDER BY i.total_carbon_footprint DESC;