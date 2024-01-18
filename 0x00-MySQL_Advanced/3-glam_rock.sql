-- Retrieve and rank bands with Glam rock as their main style based on longevity:

-- Select the 'band_name' column.
-- Calculate the 'lifespan' of each band, using the difference between the 'split' and 'formed' years.
-- If the 'split' year is NULL, assume the current year (2022) as the split year.
-- This helps calculate the lifespan even for bands that are still active.
SELECT band_name, 
       IF(split IS NULL, 2022, split) - formed AS lifespan

-- From the 'metal_bands' table.
FROM metal_bands

-- Filter bands where the 'style' column contains the string "Glam rock".
WHERE style LIKE "%Glam rock%"

-- Order the results by the calculated 'lifespan' in descending order.
ORDER BY lifespan DESC;
