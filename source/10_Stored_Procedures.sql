/*********************************************/
/*                                           */
/*          Chapter 10: Stored Procedures    */
/*                                           */
/*********************************************/

/*********************************************/
/*              Introduction                 */
/*********************************************/

-- Stored procedures are a powerful feature in SQL that allows you to encapsulate SQL code for reuse.
-- They can accept parameters, contain control-of-flow logic, and return results.
-- Stored procedures improve performance and maintainability, and they are useful for enforcing business logic.

/*********************************************/
/*         Creating Stored Procedures        */
/*********************************************/

-- Basic Syntax:
-- CREATE PROCEDURE procedure_name (parameter_list)
-- BEGIN
--     -- procedure body
-- END;

-- Example: Basic Stored Procedure
DELIMITER $$

CREATE PROCEDURE GetEmployeeCount()
BEGIN
    SELECT COUNT(*) AS total_employees FROM employees;
END $$

DELIMITER ;

/*********************************************/
/*        Parameters in Stored Procedures    */
/*********************************************/

-- Stored procedures can accept IN, OUT, and INOUT parameters.

-- IN: Input parameter (default)
-- OUT: Output parameter
-- INOUT: Input/Output parameter

-- Example: Stored Procedure with IN and OUT Parameters
DELIMITER $$

CREATE PROCEDURE GetEmployeeById(IN emp_id INT, OUT emp_first_name VARCHAR(50), OUT emp_last_name VARCHAR(50))
BEGIN
    SELECT first_name, last_name INTO emp_first_name, emp_last_name
    FROM employees
    WHERE employee_id = emp_id;
END $$

DELIMITER ;

-- Calling the procedure with IN and OUT parameters
CALL GetEmployeeById(1, @first_name, @last_name);
SELECT @first_name, @last_name;

/*********************************************/
/*           Variables in Stored Procedures  */
/*********************************************/

-- Variables can be declared and used within stored procedures.

-- Example: Using Variables in a Stored Procedure
DELIMITER $$

CREATE PROCEDURE CalculateEmployeeBonus(IN emp_id INT)
BEGIN
    DECLARE emp_salary DECIMAL(10,2);
    DECLARE bonus DECIMAL(10,2);
    
    SELECT salary INTO emp_salary FROM employees WHERE employee_id = emp_id;
    SET bonus = emp_salary * 0.10;  -- 10% bonus
    UPDATE employees SET bonus = bonus WHERE employee_id = emp_id;
END $$

DELIMITER ;

-- Calling the procedure
CALL CalculateEmployeeBonus(1);

/*********************************************/
/*            Control-of-Flow Statements     */
/*********************************************/

-- Stored procedures can contain control-of-flow statements like IF, CASE, WHILE, REPEAT, and LOOP.

-- Example: Using IF and CASE Statements
DELIMITER $$

CREATE PROCEDURE CheckEmployeeStatus(IN emp_id INT, OUT emp_status VARCHAR(20))
BEGIN
    DECLARE emp_salary DECIMAL(10,2);
    
    SELECT salary INTO emp_salary FROM employees WHERE employee_id = emp_id;
    
    IF emp_salary >= 100000 THEN
        SET emp_status = 'High Earner';
    ELSE
        SET emp_status = 'Regular Earner';
    END IF;
END $$

DELIMITER ;

-- Calling the procedure
CALL CheckEmployeeStatus(1, @status);
SELECT @status;

-- Example: Using WHILE Loop
DELIMITER $$

CREATE PROCEDURE IncreaseSalaries()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE emp_id INT;
    DECLARE cur CURSOR FOR SELECT employee_id FROM employees;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO emp_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        UPDATE employees SET salary = salary * 1.05 WHERE employee_id = emp_id;
    END LOOP;
    CLOSE cur;
END $$

DELIMITER ;

-- Calling the procedure
CALL IncreaseSalaries();

/*********************************************/
/*            Cursors in Stored Procedures   */
/*********************************************/

-- Cursors allow row-by-row processing of result sets.

-- Example: Using Cursors in Stored Procedures
DELIMITER $$

CREATE PROCEDURE ProcessEmployeeSalaries()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE emp_id INT;
    DECLARE emp_salary DECIMAL(10,2);
    DECLARE cur CURSOR FOR SELECT employee_id, salary FROM employees;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO emp_id, emp_salary;
        IF done THEN
            LEAVE read_loop;
        END IF;
        -- Process each row
        UPDATE employees SET salary = salary + (salary * 0.10) WHERE employee_id = emp_id;
    END LOOP;
    CLOSE cur;
END $$

DELIMITER ;

-- Calling the procedure
CALL ProcessEmployeeSalaries();

/*********************************************/
/*            Error Handling                 */
/*********************************************/

-- Error handling can be done using DECLARE ... HANDLER.

-- Example: Error Handling in Stored Procedures
DELIMITER $$

CREATE PROCEDURE SafeEmployeeUpdate(IN emp_id INT, IN new_salary DECIMAL(10,2))
BEGIN
    DECLARE exit HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Error handling code
        ROLLBACK;
        SELECT 'An error occurred, operation rolled back' AS error_message;
    END;
    
    START TRANSACTION;
    UPDATE employees SET salary = new_salary WHERE employee_id = emp_id;
    COMMIT;
END $$

DELIMITER ;

-- Calling the procedure with error handling
CALL SafeEmployeeUpdate(1, 120000);

/*********************************************/
/*           Managing Stored Procedures      */
/*********************************************/

-- Altering a Stored Procedure
-- MySQL does not support ALTER PROCEDURE directly. You need to drop and recreate the procedure.
DROP PROCEDURE IF EXISTS GetEmployeeCount;
DELIMITER $$
CREATE PROCEDURE GetEmployeeCount()
BEGIN
    SELECT COUNT(*) AS total_employees FROM employees;
END $$

DELIMITER ;

-- Dropping a Stored Procedure
DROP PROCEDURE IF EXISTS GetEmployeeById;

-- Listing All Stored Procedures
SHOW PROCEDURE STATUS WHERE Db = 'your_database_name';

-- Viewing Stored Procedure Code
SHOW CREATE PROCEDURE GetEmployeeCount;

/*********************************************/
/*              Variables outside            */
/*********************************************/

-- Declare and set a variable
SET @emp_salary = 1000.00;

-- Use the variable in a query
SELECT @emp_salary AS employee_salary;


/*********************************************/
/*              Best Practices               */
/*********************************************/

-- Best Practices for Using Stored Procedures:
-- 1. Keep stored procedures small and focused on a single task.
-- 2. Use meaningful names for procedures and parameters.
-- 3. Document your stored procedures with comments.
-- 4. Handle errors gracefully to avoid leaving transactions in an inconsistent state.
-- 5. Regularly review and optimize stored procedures for performance.
-- 6. Avoid using dynamic SQL within stored procedures if possible.

