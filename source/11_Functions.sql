/*********************************************/
/*                                           */
/*          Chapter 11: Functions            */
/*                                           */
/*********************************************/

/*********************************************/
/*              Introduction                 */
/*********************************************/

-- Functions in SQL are similar to stored procedures, but they can return a value and be used in SQL statements.
-- Functions can accept parameters, contain control-of-flow logic, and return a result.
-- They are useful for encapsulating reusable logic that can be used in queries.

/*********************************************/
/*        Creating and Using Functions       */
/*********************************************/

-- Basic Syntax:
-- CREATE FUNCTION function_name (parameter_list)
-- RETURNS return_datatype
-- [DETERMINISTIC | NOT DETERMINISTIC]
-- [NO SQL | CONTAINS SQL | READS SQL DATA | MODIFIES SQL DATA]
-- BEGIN
--     -- function body
--     RETURN value;
-- END;

-- Example: Basic Function
DELIMITER $$

CREATE FUNCTION GetEmployeeFullName(emp_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE full_name VARCHAR(100);
    SELECT CONCAT(first_name, ' ', last_name) INTO full_name
    FROM employees
    WHERE employee_id = emp_id;
    RETURN full_name;
END $$

DELIMITER ;

-- Using the function
SELECT GetEmployeeFullName(1) AS full_name;

/*********************************************/
/*        Parameters in Functions            */
/*********************************************/

-- Functions can accept IN parameters. OUT and INOUT parameters are not supported in functions.

-- Example: Function with Parameters
DELIMITER $$

CREATE FUNCTION CalculateBonus(salary DECIMAL(10,2), bonus_percent INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
NO SQL
BEGIN
    RETURN salary * (bonus_percent / 100);
END $$

DELIMITER ;

-- Using the function
SELECT CalculateBonus(60000, 10) AS bonus;

/*********************************************/
/*         Variables in Functions            */
/*********************************************/

-- Variables can be declared and used within functions.

-- Example: Using Variables in a Function
DELIMITER $$

CREATE FUNCTION GetEmployeeBonus(emp_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE emp_salary DECIMAL(10,2);
    DECLARE bonus DECIMAL(10,2);
    
    SELECT salary INTO emp_salary FROM employees WHERE employee_id = emp_id;
    SET bonus = emp_salary * 0.10;  -- 10% bonus
    RETURN bonus;
END $$

DELIMITER ;

-- Using the function
SELECT GetEmployeeBonus(1) AS bonus;

/*********************************************/
/*        Control-of-Flow Statements         */
/*********************************************/

-- Functions can contain control-of-flow statements like IF and CASE.

-- Example: Using IF and CASE Statements in a Function
DELIMITER $$

CREATE FUNCTION GetEmployeeStatus(emp_id INT)
RETURNS VARCHAR(20)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE emp_salary DECIMAL(10,2);
    DECLARE emp_status VARCHAR(20);
    
    SELECT salary INTO emp_salary FROM employees WHERE employee_id = emp_id;
    
    IF emp_salary >= 100000 THEN
        SET emp_status = 'High Earner';
    ELSE
        SET emp_status = 'Regular Earner';
    END IF;
    
    RETURN emp_status;
END $$

DELIMITER ;

-- Using the function
SELECT GetEmployeeStatus(1) AS status;

/*********************************************/
/*             Aggregate Functions           */
/*********************************************/

-- MySQL provides several built-in aggregate functions for performing calculations on a set of values.

-- COUNT(): Returns the number of rows
SELECT COUNT(*) AS total_employees FROM employees;

-- SUM(): Returns the sum of values
SELECT SUM(salary) AS total_salary FROM employees;

-- AVG(): Returns the average value
SELECT AVG(salary) AS average_salary FROM employees;

-- MIN(): Returns the minimum value
SELECT MIN(salary) AS minimum_salary FROM employees;

-- MAX(): Returns the maximum value
SELECT MAX(salary) AS maximum_salary FROM employees;

/*********************************************/
/*          String Functions                 */
/*********************************************/

-- MySQL provides several built-in string functions for manipulating strings.

-- LENGTH(): Returns the length of a string
SELECT LENGTH('Hello World') AS string_length;

-- CONCAT(): Concatenates strings
SELECT CONCAT('Hello', ' ', 'World') AS concatenated_string;

-- SUBSTRING(): Extracts a substring from a string
SELECT SUBSTRING('Hello World', 1, 5) AS substring;

-- UPPER(): Converts a string to uppercase
SELECT UPPER('Hello World') AS uppercase_string;

-- LOWER(): Converts a string to lowercase
SELECT LOWER('Hello World') AS lowercase_string;

-- REPLACE(): Replaces occurrences of a substring
SELECT REPLACE('Hello World', 'World', 'MySQL') AS replaced_string;

/*********************************************/
/*           Date and Time Functions         */
/*********************************************/

-- MySQL provides several built-in date and time functions for manipulating dates and times.

-- NOW(): Returns the current date and time
SELECT NOW() AS current_datetime;

-- CURDATE(): Returns the current date
SELECT CURDATE() AS 'current_date';

-- CURTIME(): Returns the current time
SELECT CURTIME() AS 'current_time';

-- DATE_FORMAT(): Formats a date
SELECT DATE_FORMAT(NOW(), '%Y-%m-%d') AS formatted_date;

-- DATE_ADD(): Adds an interval to a date
SELECT DATE_ADD(NOW(), INTERVAL 1 DAY) AS next_day;

-- DATE_SUB(): Subtracts an interval from a date
SELECT DATE_SUB(NOW(), INTERVAL 1 MONTH) AS previous_month;

-- DATEDIFF(): Returns the difference between two dates
SELECT DATEDIFF('2023-12-31', '2023-01-01') AS date_difference;

/*********************************************/
/*              Mathematical Functions       */
/*********************************************/

-- MySQL provides several built-in mathematical functions for performing calculations.

-- ABS(): Returns the absolute value
SELECT ABS(-123) AS absolute_value;

-- CEIL(): Returns the smallest integer value greater than or equal to a number
SELECT CEIL(123.45) AS ceiling_value;

-- FLOOR(): Returns the largest integer value less than or equal to a number
SELECT FLOOR(123.45) AS floor_value;

-- ROUND(): Rounds a number to a specified number of decimal places
SELECT ROUND(123.456, 2) AS rounded_value;

-- SQRT(): Returns the square root of a number
SELECT SQRT(16) AS square_root;

-- POW(): Returns a number raised to the power of another number
SELECT POW(2, 3) AS power_value;

-- LOG(): Returns the natural logarithm of a number
SELECT LOG(100) AS natural_log;

-- LOG10(): Returns the base-10 logarithm of a number
SELECT LOG10(100) AS base10_log;

-- MOD(): Returns the remainder of a division
SELECT MOD(10, 3) AS remainder;

-- RAND(): Returns a random number between 0 and 1
SELECT RAND() AS random_value;

/*********************************************/
/*              Managing Functions           */
/*********************************************/

-- Altering a Function
-- MySQL does not support ALTER FUNCTION directly. You need to drop and recreate the function.
DROP FUNCTION IF EXISTS GetEmployeeFullName;
DELIMITER $$
CREATE FUNCTION GetEmployeeFullName(emp_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE full_name VARCHAR(100);
    SELECT CONCAT(first_name, ' ', last_name) INTO full_name
    FROM employees
    WHERE employee_id = emp_id;
    RETURN full_name;
END $$
DELIMITER ;

-- Dropping a Function
DROP FUNCTION IF EXISTS CalculateBonus;

-- Listing All Functions
SHOW FUNCTION STATUS WHERE Db = 'your_database_name';

-- Viewing Function Code
SHOW CREATE FUNCTION GetEmployeeFullName;

/*********************************************/
/*              Best Practices               */
/*********************************************/

-- Best Practices for Using Functions:
-- 1. Keep functions small and focused on a single task.
-- 2. Use meaningful names for functions and parameters.
-- 3. Document your functions with comments.
-- 4. Handle errors gracefully within functions.
-- 5. Avoid using dynamic SQL within functions if possible.
-- 6. Regularly review and optimize functions for performance.
-- 7. Test functions thoroughly to ensure they work as expected.
