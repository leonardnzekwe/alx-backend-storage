-- Create a view named 'need_meeting' that lists students requiring a meeting based on certain criteria.
-- The view includes students with a score under 80 (strict) and either no last meeting recorded or a last meeting recorded more than 1 month ago.
CREATE VIEW need_meeting AS
SELECT name
FROM students
WHERE score < 80 AND (last_meeting IS NULL OR DATEDIFF(CURDATE(), last_meeting) > 30);
