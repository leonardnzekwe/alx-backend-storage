-- Create a function named 'SafeDiv' that divides the first number by the second number
-- and returns the result or 0 if the second number is equal to 0.
-- The 'DETERMINISTIC' keyword indicates that the function will always return the same result for the same input values.
CREATE FUNCTION SafeDiv(a INT, b INT)
RETURNS FLOAT
DETERMINISTIC
RETURN IF(b = 0, 0, a / b);
