/*********************************************/
/*                                           */
/* Chapter 1: Data Definition Language (DDL) */
/*                                           */
/*********************************************/

-- DDL (Data Definition Language): CREATE, ALTER, DROP, TRUNCATE
-- DDL statements are used to define and modify the structure of database objects like tables, indexes, and views. 
-- They primarily deal with the schema of the database.

/*********************************************/
/*        CREATE Statements                  */
/*********************************************/

-- Create a new table
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,  -- Auto-incrementing primary key
    first_name VARCHAR(50) NOT NULL,             -- First name, cannot be null
    last_name VARCHAR(50) NOT NULL,              -- Last name, cannot be null
    hire_date DATE                               -- Hire date
);

-- Create a new database
CREATE DATABASE company_db;

-- Create an index
CREATE INDEX idx_last_name
ON employees (last_name);  -- Index on the last name column for faster searches

-- Create a view
CREATE VIEW employee_view AS
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date > '2020-01-01';  -- View with employees hired after January 1, 2020

/*********************************************/
/*        ALTER Statements                   */
/*********************************************/

-- Add a column to a table
ALTER TABLE employees
ADD email VARCHAR(100);  -- Adding an email column

-- Modify a column in a table
ALTER TABLE employees
MODIFY hire_date DATETIME;  -- Changing hire_date column to DATETIME type

-- Drop a column from a table
ALTER TABLE employees
DROP COLUMN email;  -- Removing the email column

-- Rename a column in a table
ALTER TABLE employees
RENAME COLUMN hire_date TO start_date;  -- Renaming hire_date to start_date

-- Rename a table
ALTER TABLE employees
RENAME TO staff;  -- Renaming the employees table to staff

/*********************************************/
/*        DROP Statements                    */
/*********************************************/

-- Drop a table
DROP TABLE employees;  -- Permanently removes the employees table and all its data

-- Drop a database
DROP DATABASE company_db;  -- Permanently removes the company_db database and all its tables

-- Drop an index
DROP INDEX idx_last_name
ON employees;  -- Removes the idx_last_name index from the employees table

-- Drop a view
DROP VIEW employee_view;  -- Removes the employee_view

/*********************************************/
/*        TRUNCATE Statements                */
/*********************************************/

-- Truncate a table
TRUNCATE TABLE employees;  -- Removes all rows from the employees table, resetting auto-increment values
