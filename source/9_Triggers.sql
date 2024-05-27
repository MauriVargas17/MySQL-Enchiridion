
/*********************************************/
/*                                           */
/*          Chapter 9: Triggers              */
/*                                           */
/*********************************************/

/*********************************************/
/*              Introduction                 */
/*********************************************/

-- Triggers are database callback functions that are automatically performed/invoked when a specified database event occurs.
-- They are used to perform actions before or after INSERT, UPDATE, and DELETE operations on a table.

-- Basic Syntax:
-- CREATE TRIGGER trigger_name trigger_time trigger_event
-- ON table_name FOR EACH ROW
-- BEGIN
--     -- trigger body
-- END;

/*********************************************/
/*              Types of Triggers            */
/*********************************************/

-- There are six types of triggers based on the combination of trigger_time and trigger_event:

-- 1. BEFORE INSERT
-- 2. AFTER INSERT
-- 3. BEFORE UPDATE
-- 4. AFTER UPDATE
-- 5. BEFORE DELETE
-- 6. AFTER DELETE

-- Trigger Times:
-- BEFORE: The trigger activates before the operation.
-- AFTER: The trigger activates after the operation.

-- Trigger Events:
-- INSERT: The trigger activates for INSERT operations.
-- UPDATE: The trigger activates for UPDATE operations.
-- DELETE: The trigger activates for DELETE operations.

/*********************************************/
/*         Creating Triggers                 */
/*********************************************/

-- Example: BEFORE INSERT Trigger
-- This trigger automatically sets the created_at field to the current timestamp before inserting a new row.

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    created_at TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER before_insert_employees
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    SET NEW.created_at = NOW();
END $$

DELIMITER ;

-- Example: AFTER INSERT Trigger
-- This trigger inserts a log entry into an audit table after a new row is inserted into the employees table.

CREATE TABLE audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    operation VARCHAR(50),
    operation_date DATETIME,
    employee_id INT
);

DELIMITER $$

CREATE TRIGGER after_insert_employees
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (operation, operation_date, employee_id)
    VALUES ('INSERT', NOW(), NEW.employee_id);
END $$

DELIMITER ;

/*********************************************/
/*            Using Triggers                 */
/*********************************************/

-- Insert a new employee to see triggers in action.
INSERT INTO employees (first_name, last_name) VALUES ('John', 'Doe');

-- Check the employees table.
SELECT * FROM employees;

-- Check the audit_log table.
SELECT * FROM audit_log;

/*********************************************/
/*            Special Cases                  */
/*********************************************/

-- Handling Errors in Triggers
-- You can use error handling to ensure that your trigger logic is robust.

DELIMITER $$

CREATE TRIGGER before_insert_employees
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.first_name IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'First name cannot be null';
    END IF;
    SET NEW.created_at = NOW();
END $$

DELIMITER ;

/*********************************************/
/*         Advanced Trigger Usage            */
/*********************************************/

-- BEFORE UPDATE Trigger
-- This trigger sets the updated_at field to the current timestamp before updating a row.

ALTER TABLE employees ADD COLUMN updated_at TIMESTAMP;

DELIMITER $$

CREATE TRIGGER before_update_employees
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
END $$

DELIMITER ;

-- AFTER DELETE Trigger
-- This trigger logs the deletion of an employee.

DELIMITER $$

CREATE TRIGGER after_delete_employees
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (operation, operation_date, employee_id)
    VALUES ('DELETE', NOW(), OLD.employee_id);
END $$

DELIMITER ;

/*********************************************/
/*            Managing Triggers              */
/*********************************************/

-- Listing Triggers
-- To list all triggers in the database:
SELECT * FROM information_schema.triggers WHERE trigger_schema = 'your_database_name';

-- Dropping Triggers
-- To drop a trigger:
DROP TRIGGER IF EXISTS before_insert_employees;
DROP TRIGGER IF EXISTS after_insert_employees;

/*********************************************/
/*             Case Studies                  */
/*********************************************/

-- Case Study 1: Enforcing Business Rules
-- A BEFORE INSERT trigger can enforce business rules, such as ensuring that an employee's age is within a valid range.

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER before_insert_employees
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    DECLARE age INT;
    SET age = TIMESTAMPDIFF(YEAR, NEW.birth_date, CURDATE());
    IF age < 18 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee must be at least 18 years old';
    END IF;
    SET NEW.created_at = NOW();
END $$

DELIMITER ;

-- Case Study 2: Auditing Changes
-- An AFTER UPDATE trigger can be used to audit changes to important fields in a table.

DELIMITER $$

CREATE TRIGGER after_update_employees
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF NEW.last_name <> OLD.last_name THEN
        INSERT INTO audit_log (operation, operation_date, employee_id)
        VALUES ('UPDATE', NOW(), NEW.employee_id);
    END IF;
END $$

DELIMITER ;

/*********************************************/
/*        Impacting the same table           */
/*********************************************/

-- Example Table
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    full_name VARCHAR(100)
);

-- Trigger that updates the full_name column after an insert
DELIMITER $$

CREATE TRIGGER before_insert_employees
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    SET NEW.full_name = CONCAT(NEW.first_name, ' ', NEW.last_name);
END $$

DELIMITER ;

-- Insert a new employee to trigger the update
INSERT INTO employees (first_name, last_name) VALUES ('John', 'Doe');

-- Check the updated table
SELECT * FROM employees;

/*********************************************/
/*            Best Practices                 */
/*********************************************/

-- Best Practices for Using Triggers:
-- 1. Keep triggers as simple as possible to avoid performance issues.
-- 2. Use triggers to enforce business rules and maintain data integrity.
-- 3. Be cautious with triggers that modify data, as they can lead to recursive trigger execution.
-- 4. Document your triggers thoroughly to ensure maintainability.
-- 5. Regularly monitor trigger performance and impact on your database.

