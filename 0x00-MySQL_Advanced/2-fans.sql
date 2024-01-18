-- Retrieve and rank country origins of metal bands based on the total number of fans:

-- Select the 'origin' column (country of origin) and the sum of 'fans' for each country.
-- The result is aliased as 'nb_fans' for clarity.
SELECT origin, SUM(fans) as nb_fans

-- From the 'metal_bands' table.
FROM metal_bands

-- Group the results by the 'origin' column.
GROUP BY origin

-- Order the results by the total number of fans in descending order.
ORDER BY nb_fans DESC;
