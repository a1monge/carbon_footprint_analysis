
-- 1. Average Emissions per Capita by Industry
SELECT l.industry, ROUND(AVG(e.[column_name] / e."Total CO2/cap"), 2) AS AvgEmissionsPerCapita
FROM emissions e
JOIN industry_lookup l ON 1=1
GROUP BY l.industry
ORDER BY AvgEmissionsPerCapita DESC;

-- 2. Industry-Wise Total Emissions Across All Years
WITH industry_totals AS (
    SELECT l.industry, SUM(e.[column_name]) AS total_emissions
    FROM emissions e
    JOIN industry_lookup l ON 1=1
    GROUP BY l.industry
),
total_footprint AS (
    SELECT SUM(Agriculture + Buildings + "Fuel Exploitation" + "Industrial Combustion" + "Power Industry" + Processes + Transport + Waste) AS global_total
    FROM emissions
)
SELECT 
    i.industry,
    printf('%.2f tons', i.total_emissions) AS total_emissions,
    printf('%.2f%%', (i.total_emissions * 100.0 / t.global_total)) AS percent_contribution
FROM industry_totals i
JOIN total_footprint t ON 1=1
ORDER BY i.total_emissions DESC;

-- 3. Top Year for Each Industry
SELECT l.industry, e.Category AS "Top Year", 
    printf('%d tons', MAX(e.[column_name])) AS Emissions
FROM emissions e
JOIN industry_lookup l ON 1=1
GROUP BY l.industry
ORDER BY industry;
