
-- 1. Average Emissions per Capita by Industry
SELECT 
    'Agriculture' AS Industry,
    ROUND(AVG(Agriculture / "Total CO2/cap"), 2) AS AvgEmissionsPerCapita
FROM emissions
UNION ALL
SELECT 
    'Buildings',
    ROUND(AVG(Buildings / "Total CO2/cap"), 2)
FROM emissions
UNION ALL
SELECT 
    'Fuel Exploitation',
    ROUND(AVG("Fuel Exploitation" / "Total CO2/cap"), 2)
FROM emissions
UNION ALL
SELECT 
    'Industrial Combustion',
    ROUND(AVG("Industrial Combustion" / "Total CO2/cap"), 2)
FROM emissions
UNION ALL
SELECT 
    'Power Industry',
    ROUND(AVG("Power Industry" / "Total CO2/cap"), 2)
FROM emissions
UNION ALL
SELECT 
    'Processes',
    ROUND(AVG(Processes / "Total CO2/cap"), 2)
FROM emissions
UNION ALL
SELECT 
    'Transport',
    ROUND(AVG(Transport / "Total CO2/cap"), 2)
FROM emissions
UNION ALL
SELECT 
    'Waste',
    ROUND(AVG(Waste / "Total CO2/cap"), 2)
FROM emissions
ORDER BY AvgEmissionsPerCapita DESC;

-- 2. Industry-Wise Total Emissions Across All Years
WITH industry_totals AS (
    SELECT 'Agriculture' AS industry_group, SUM(Agriculture) AS total_emissions FROM emissions
    UNION ALL
    SELECT 'Buildings', SUM(Buildings) FROM emissions
    UNION ALL
    SELECT 'Fuel Exploitation', SUM("Fuel Exploitation") FROM emissions
    UNION ALL
    SELECT 'Industrial Combustion', SUM("Industrial Combustion") FROM emissions
    UNION ALL
    SELECT 'Power Industry', SUM("Power Industry") FROM emissions
    UNION ALL
    SELECT 'Processes', SUM(Processes) FROM emissions
    UNION ALL
    SELECT 'Transport', SUM(Transport) FROM emissions
    UNION ALL
    SELECT 'Waste', SUM(Waste) FROM emissions
),
total_footprint AS (
    SELECT SUM(Agriculture + Buildings + "Fuel Exploitation" + "Industrial Combustion" + "Power Industry" + Processes + Transport + Waste) AS global_total
    FROM emissions
)
SELECT 
    i.industry_group,
    CONCAT(i.total_emissions, ' tons') AS total_emissions,
    CONCAT(ROUND((i.total_emissions * 100.0 / t.global_total), 2), '%') AS percent_contribution
FROM industry_totals i
JOIN total_footprint t ON 1 = 1
ORDER BY i.total_emissions DESC;

-- 3. Top Year for Each Industry
SELECT 
    'Agriculture' AS Industry,
    Category AS "Top Year",
    CONCAT(MAX(Agriculture), ' tons') AS Emissions
FROM emissions
UNION ALL
SELECT 
    'Buildings',
    Category,
    CONCAT(MAX(Buildings), ' tons')
FROM emissions
UNION ALL
SELECT 
    'Fuel Exploitation',
    Category,
    CONCAT(MAX("Fuel Exploitation"), ' tons')
FROM emissions
UNION ALL
SELECT 
    'Industrial Combustion',
    Category,
    CONCAT(MAX("Industrial Combustion"), ' tons')
FROM emissions
UNION ALL
SELECT 
    'Power Industry',
    Category,
    CONCAT(MAX("Power Industry"), ' tons')
FROM emissions
UNION ALL
SELECT 
    'Processes',
    Category,
    CONCAT(MAX(Processes), ' tons')
FROM emissions
UNION ALL
SELECT 
    'Transport',
    Category,
    CONCAT(MAX(Transport), ' tons')
FROM emissions
UNION ALL
SELECT 
    'Waste',
    Category,
    CONCAT(MAX(Waste), ' tons')
FROM emissions
ORDER BY Industry;