-- Change the delimiter to $$ to allow for the creation of the stored procedure.
DELIMITER $$

-- Create a stored procedure named 'AddBonus' with three input parameters.
CREATE PROCEDURE AddBonus(IN user_id INT, IN project_name VARCHAR(225), IN score FLOAT)
BEGIN
    -- Check if the project with the specified name exists in the 'projects' table.
    -- If not, insert a new project with the specified name.
    IF NOT EXISTS (SELECT * FROM projects WHERE name = project_name) THEN
        INSERT INTO projects (name) VALUES (project_name);
    END IF;

    -- Retrieve the 'id' of the project with the specified name.
    SET @id = (SELECT id FROM projects WHERE name = project_name);

    -- Insert a new correction into the 'corrections' table with the specified user, project, and score.
    INSERT INTO corrections (user_id, project_id, score) VALUES (user_id, @id, score);
END $$

-- Reset the delimiter back to ;
DELIMITER ;
