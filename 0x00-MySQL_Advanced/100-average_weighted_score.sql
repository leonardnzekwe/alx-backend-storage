-- Change the delimiter to $$ to allow for the creation of the stored procedure.
DELIMITER $$

-- Create a stored procedure named 'ComputeAverageWeightedScoreForUser' with one input parameter.
CREATE PROCEDURE ComputeAverageWeightedScoreForUser(IN u_id INT)
BEGIN
    -- Calculate the average weighted score for the specified user.
    SET @av = (
        SELECT SUM(corrections.score * projects.weight) / SUM(projects.weight) AS av
        FROM projects
        JOIN corrections ON corrections.project_id = projects.id
        WHERE user_id = u_id
    );

    -- Update the 'average_score' column in the 'users' table with the calculated average.
    UPDATE users SET average_score = @av WHERE id = u_id;
END $$

-- Reset the delimiter back to ;
DELIMITER ;
