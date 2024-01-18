-- Create a table named 'users' with the following columns:

-- Column 'id': Primary key for the table, an integer with auto-incrementing values.
-- Not null ensures that each record has a unique identifier.
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,

    -- Column 'email': Unique email addresses for each user, maximum length of 225 characters.
    -- Not null ensures that each user must have a valid email.
    email VARCHAR(225) UNIQUE NOT NULL,

    -- Column 'name': User's name, maximum length of 225 characters.
    -- This column can contain NULL values, as it's not marked as NOT NULL.
    name VARCHAR(225),

    -- Column 'country': Enumerated type representing user's country.
    -- Not null ensures that each user must have a valid country.
    -- Default value is set to 'US'.
    country ENUM('US', 'CO', 'TN') NOT NULL DEFAULT 'US'
);
