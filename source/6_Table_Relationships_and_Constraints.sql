
/**************************************************/
/*                                                */
/* Chapter 6: Table Relationships and Constraints */
/*                                                */
/**************************************************/

/*********************************************/
/*        Primary Keys                       */
/*********************************************/

-- A primary key is a unique identifier for a record in a table. 
-- Each table can have only one primary key, and it cannot contain NULL values.

-- Create a table with a primary key
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,  -- Auto-incrementing primary key
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    hire_date DATE
);

/*********************************************/
/*        Foreign Keys                       */
/*********************************************/

-- A foreign key is a field (or collection of fields) in one table that refers to the primary key in another table.
-- It is used to link two tables together.

-- Create a table with a foreign key
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL
);

CREATE TABLE employee_departments (
    employee_id INT,
    department_id INT,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

/*********************************************/
/*        Unique Constraints                 */
/*********************************************/

-- A unique constraint ensures that all values in a column are different.
-- This is different from a primary key because a table can have multiple unique constraints.

-- Create a table with a unique constraint
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE  -- Ensures all email values are unique
);

/*********************************************/
/*        Check Constraints                  */
/*********************************************/

-- A check constraint ensures that all values in a column satisfy a specific condition.
-- This helps to enforce data integrity at the database level.

-- Create a table with a check constraint
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) CHECK (price > 0)  -- Ensures price is greater than 0
);

/*********************************************/
/*        Cascading Actions                  */
/*********************************************/

-- Cascading actions define what happens when a referenced row in a foreign key relationship is updated or deleted.
-- Common actions are CASCADE, SET NULL, and RESTRICT.

-- Create tables with cascading actions
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL
);

-- Create a default customer to be used when other customers are deleted
INSERT INTO customers (customer_name) VALUES ('Default Customer');

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    ON DELETE SET NULL  -- Temporarily set to NULL, we'll handle the default assignment with a trigger
    ON UPDATE CASCADE  -- Updates order's customer_id when the referenced customer_id is updated
);

/*********************************************/
/*        Example of Cascading Actions       */
/*********************************************/

-- Example to demonstrate cascading actions:
-- 1. Insert a customer.
INSERT INTO customers (customer_name) VALUES ('John Doe');

-- 2. Insert an order for the customer.
INSERT INTO orders (customer_id, order_date) VALUES (LAST_INSERT_ID(), '2023-01-01');

-- 3. Check the current orders.
SELECT * FROM orders;

-- 4. Update the customer_id in the customers table.
UPDATE customers SET customer_id = 2 WHERE customer_name = 'John Doe';

-- 5. Check the orders again to see the update.
SELECT * FROM orders;

-- In this example, if the customer_id for 'John Doe' is updated from 1 to 2 in the customers table,
-- the corresponding customer_id in the orders table will also be updated to 2 due to the ON UPDATE CASCADE action.
-- This ensures that the orders are still correctly associated with the customer, maintaining referential integrity.

/*********************************************/
/*        Triggers for Cascading Actions     */
/*********************************************/

-- Create a trigger to handle the default assignment when a customer is deleted
DELIMITER $$

CREATE TRIGGER before_customer_delete
BEFORE DELETE ON customers
FOR EACH ROW
BEGIN
    IF OLD.customer_id <> (SELECT customer_id FROM customers WHERE customer_name = 'Default Customer') THEN
        UPDATE orders SET customer_id = (SELECT customer_id FROM customers WHERE customer_name = 'Default Customer') 
        WHERE customer_id = OLD.customer_id;
    END IF;
END $$

DELIMITER ;

/*********************************************/
/*        Example of Cascading Actions with Trigger */
/*********************************************/

-- Insert some initial data
INSERT INTO customers (customer_name) VALUES ('John Doe');
INSERT INTO orders (customer_id, order_date) VALUES ((SELECT customer_id FROM customers WHERE customer_name = 'John Doe'), '2023-01-01');

-- Check current orders
SELECT * FROM orders;

-- Delete the customer 'John Doe'
DELETE FROM customers WHERE customer_name = 'John Doe';

-- Check the orders again to see the default customer ID
SELECT * FROM orders;

-- In this example, if the customer 'John Doe' is deleted,
-- the customer_id in the orders table will be set to the default customer ID using the trigger.

