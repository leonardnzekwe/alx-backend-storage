-- Change the delimiter to $$ to allow for the creation of the trigger.
DELIMITER $$

-- Create a trigger named 'reset_valid_email' that activates before an update operation on the 'users' table.
CREATE TRIGGER reset_valid_email
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    -- Check if the 'email' column is being updated.
    -- If the new email is different from the old email, set 'valid_email' to 0.
    IF NEW.email != OLD.email THEN
        SET NEW.valid_email = 0;
    END IF;
END $$

-- Reset the delimiter back to ;
DELIMITER ;
