-- Create an index named 'idx_name_first_score' on the table 'names' for the first letter of the 'name' column and the 'score' column.
CREATE INDEX idx_name_first_score ON names (name(1), score);
