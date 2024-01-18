-- Change the delimiter to $$ to allow for the creation of the stored procedure.
DELIMITER $$

-- Create a stored procedure named 'ComputeAverageScoreForUser' with one input parameter.
CREATE PROCEDURE ComputeAverageScoreForUser(IN u_id INT)
BEGIN
    -- Calculate the average score for the specified user.
    SET @av = (SELECT AVG(score) AS av FROM corrections WHERE user_id = u_id);

    -- Update the 'average_score' column in the 'users' table with the calculated average.
    UPDATE users SET average_score = @av WHERE id = u_id;
END $$

-- Reset the delimiter back to ;
DELIMITER ;
