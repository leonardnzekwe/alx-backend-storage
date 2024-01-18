-- Drop existing stored procedures to avoid conflicts.
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUser;
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers;

-- Change the delimiter to $$ to allow for the creation of the stored procedures.
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

-- Create a stored procedure named 'ComputeAverageWeightedScoreForUsers' with no input parameters.
CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    -- Declare a variable to store the total number of rows in the 'users' table.
    DECLARE all_rows INT;

    -- Get the total number of rows in the 'users' table.
    SET all_rows = (SELECT COUNT(*) FROM users);

    -- Loop through all users and call 'ComputeAverageWeightedScoreForUser' for each user.
    WHILE all_rows > 0 DO
        CALL ComputeAverageWeightedScoreForUser(all_rows);
        SET all_rows = all_rows - 1;
    END WHILE;
END $$

-- Reset the delimiter back to ;
DELIMITER ;
