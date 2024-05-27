/*********************************************/
/*                                           */
/*           Chapter 14: Error Handling      */
/*                                           */
/*********************************************/

/*********************************************/
/*              Introduction                 */
/*********************************************/

-- Error handling in MySQL involves managing and responding to errors that occur during SQL statement execution.
-- Proper error handling helps maintain data integrity and provides meaningful feedback to users and applications.

-- Key Concepts:
-- 1. DECLARE ... HANDLER
-- 2. EXIT HANDLER
-- 3. CONTINUE HANDLER
-- 4. CONDITION
-- 5. GET DIAGNOSTICS

/*********************************************/
/*           DECLARE ... HANDLER             */
/*********************************************/

-- The DECLARE ... HANDLER statement specifies actions to take when certain conditions occur.
-- You can define handlers for different conditions such as SQLEXCEPTION, SQLWARNING, or NOT FOUND.

-- Syntax:
-- DECLARE handler_type HANDLER FOR condition
--     handler_action;

-- Example: Handling a Generic SQL Exception
DELIMITER $$

CREATE PROCEDURE error_handling_example()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Error handling code
        ROLLBACK;
        SELECT 'An error occurred. Operation rolled back.' AS error_message;
    END;

    START TRANSACTION;

    -- Intentionally cause an error (e.g., inserting a duplicate primary key)
    INSERT INTO employees (employee_id, first_name, last_name, department_id, salary, hire_date)
    VALUES (1, 'John', 'Doe', 1, 60000, '2022-01-01');

    COMMIT;
END $$

DELIMITER ;

-- Calling the procedure
CALL error_handling_example();

/*********************************************/
/*           EXIT and CONTINUE HANDLER       */
/*********************************************/

-- EXIT HANDLER: Terminates the execution of the enclosing block of code.
-- CONTINUE HANDLER: Continues the execution of the next statement in the block after the handler is executed.

-- Example: Using EXIT HANDLER
DELIMITER $$

CREATE PROCEDURE exit_handler_example()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Error handling code
        SELECT 'An error occurred. Exiting the procedure.' AS error_message;
    END;

    -- Intentionally cause an error (e.g., inserting a duplicate primary key)
    INSERT INTO employees (employee_id, first_name, last_name, department_id, salary, hire_date)
    VALUES (1, 'John', 'Doe', 1, 60000, '2022-01-01');
END $$

DELIMITER ;

-- Calling the procedure
CALL exit_handler_example();

-- Example: Using CONTINUE HANDLER
DELIMITER $$

CREATE PROCEDURE continue_handler_example()
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Error handling code
        SELECT 'An error occurred. Continuing the procedure.' AS error_message;
    END;

    -- Intentionally cause an error (e.g., inserting a duplicate primary key)
    INSERT INTO employees (employee_id, first_name, last_name, department_id, salary, hire_date)
    VALUES (1, 'John', 'Doe', 1, 60000, '2022-01-01');

    -- This statement will be executed even after the error
    SELECT 'This statement executes after the error.' AS message;
END $$

DELIMITER ;

-- Calling the procedure
CALL continue_handler_example();

/*********************************************/
/*              CONDITION                    */
/*********************************************/

-- The CONDITION statement is used to declare named conditions that can be referenced in handlers.

-- Example: Using CONDITION
alter table employees add column hire_date date;

DELIMITER $$

CREATE PROCEDURE condition_example()
BEGIN
    DECLARE duplicate_key CONDITION FOR SQLSTATE '23000';
    DECLARE EXIT HANDLER FOR duplicate_key
    BEGIN
        -- Error handling code
        SELECT 'Duplicate key error occurred. Exiting the procedure.' AS error_message;
    END;

    -- Intentionally cause a duplicate key error
    INSERT INTO employees (employee_id, first_name, last_name, department_id, salary, hire_date)
    VALUES (1, 'John', 'Doe', 1, 60000, '2022-01-01');
END $$

DELIMITER ;

-- Calling the procedure
CALL condition_example();

/*********************************************/
/*           GET DIAGNOSTICS                 */
/*********************************************/

-- The GET DIAGNOSTICS statement is used to retrieve detailed information about the last error that occurred.

-- Example: Using GET DIAGNOSTICS
DELIMITER $$

CREATE PROCEDURE diagnostics_example()
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        DECLARE error_message VARCHAR(255);
        DECLARE error_code INT;
        
        -- Retrieve error information
        GET DIAGNOSTICS CONDITION 1
            error_message = MESSAGE_TEXT,
            error_code = MYSQL_ERRNO;
        
        SELECT CONCAT('Error ', error_code, ': ', error_message) AS error_details;
    END;

    -- Intentionally cause an error (e.g., inserting a duplicate primary key)
    INSERT INTO employees (employee_id, first_name, last_name, department_id, salary, hire_date)
    VALUES (1, 'John', 'Doe', 1, 60000, '2022-01-01');
END $$

DELIMITER ;

-- Calling the procedure
CALL diagnostics_example();

/*********************************************/
/*          Handling Transaction Errors      */
/*********************************************/

-- Example: Handling Errors in Transactions
DELIMITER $$

CREATE PROCEDURE transaction_error_handling_example()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Error handling code
        ROLLBACK;
        SELECT 'An error occurred. Transaction rolled back.' AS error_message;
    END;

    START TRANSACTION;

    -- Valid insert
    INSERT INTO employees (employee_id, first_name, last_name, department_id, salary, hire_date)
    VALUES (10, 'Alice', 'Johnson', 2, 70000, '2022-02-15');

    -- Intentionally cause an error (e.g., inserting a duplicate primary key)
    INSERT INTO employees (employee_id, first_name, last_name, department_id, salary, hire_date)
    VALUES (1, 'John', 'Doe', 1, 60000, '2022-01-01');

    COMMIT;
END $$

DELIMITER ;

-- Calling the procedure
CALL transaction_error_handling_example();

/*********************************************/
/*              Best Practices               */
/*********************************************/

-- Best Practices for Error Handling:
-- 1. Use appropriate handlers (EXIT, CONTINUE) based on the desired control flow.
-- 2. Use named conditions to improve code readability and maintainability.
-- 3. Use GET DIAGNOSTICS to retrieve detailed error information for debugging.
-- 4. Ensure proper transaction handling to maintain data integrity.
-- 5. Document error handling strategies and scenarios to ensure clarity and consistency.
-- 6. Test error handling thoroughly to ensure robustness and reliability.

