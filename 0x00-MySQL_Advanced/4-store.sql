-- Change the delimiter to $$ to allow for the creation of the trigger.
DELIMITER $$

-- Create a trigger named 'decrease_items' that activates after an insert operation on the 'orders' table.
CREATE TRIGGER decrease_items
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    -- Update the 'items' table by decreasing the quantity of the ordered item.
    -- Use the NEW keyword to reference the values of the newly inserted row in the 'orders' table.
    UPDATE items
    SET quantity = quantity - NEW.number
    WHERE name = NEW.item_name;
END $$

-- Reset the delimiter back to ;
DELIMITER ;
