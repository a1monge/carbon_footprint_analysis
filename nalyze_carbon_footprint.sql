-- 1. Average Emissions per Capita by Industry
SELECT 
    l.industry, 
    ROUND(AVG(
        CASE l.industry
            WHEN 'Agriculture' THEN e.Agriculture
            WHEN 'Buildings' THEN e.Buildings
            WHEN 'Fuel Exploitation' THEN e."Fuel Exploitation"
            WHEN 'Industrial Combustion' THEN e."Industrial Combustion"
            WHEN 'Power Industry' THEN e."Power Industry"
            WHEN 'Processes' THEN e.Processes
            WHEN 'Transport' THEN e.Transport
            WHEN 'Waste' THEN e.Waste
        END / e."Total CO2/cap"), 2) AS AvgEmissionsPerCapita
FROM emissions e
JOIN industry_lookup l ON e.industry = l.industry  
GROUP BY l.industry
ORDER BY AvgEmissionsPerCapita DESC;

-- 2. Industry-Wise Total Emissions Across All Years
WITH industry_totals AS (
    SELECT 
        l.industry, 
        SUM(
            CASE l.industry
                WHEN 'Agriculture' THEN e.Agriculture
                WHEN 'Buildings' THEN e.Buildings
                WHEN 'Fuel Exploitation' THEN e."Fuel Exploitation"
                WHEN 'Industrial Combustion' THEN e."Industrial Combustion"
                WHEN 'Power Industry' THEN e."Power Industry"
                WHEN 'Processes' THEN e.Processes
                WHEN 'Transport' THEN e.Transport
                WHEN 'Waste' THEN e.Waste
            END
        ) AS total_emissions
    FROM emissions e
    JOIN industry_lookup l ON e.industry = l.industry  
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
SELECT 
    l.industry, 
    e.Category AS "Top Year", 
    printf('%d tons', MAX(
        CASE l.industry
            WHEN 'Agriculture' THEN e.Agriculture
            WHEN 'Buildings' THEN e.Buildings
            WHEN 'Fuel Exploitation' THEN e."Fuel Exploitation"
            WHEN 'Industrial Combustion' THEN e."Industrial Combustion"
            WHEN 'Power Industry' THEN e."Power Industry"
            WHEN 'Processes' THEN e.Processes
            WHEN 'Transport' THEN e.Transport
            WHEN 'Waste' THEN e.Waste
        END
    )) AS Emissions
FROM emissions e
JOIN industry_lookup l ON e.industry = l.industry 
GROUP BY l.industry
ORDER BY l.industry;
