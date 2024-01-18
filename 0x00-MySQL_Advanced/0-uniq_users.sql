-- Create a table named 'users' with the following columns:

-- Column 'id': Primary key for the table, an integer with auto-incrementing values.
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,

    -- Column 'email': Unique email addresses for each user, maximum length of 225 characters.
    email VARCHAR(225) UNIQUE NOT NULL,

    -- Column 'name': User's name, maximum length of 225 characters, not necessarily unique.
    name VARCHAR(225)
);
