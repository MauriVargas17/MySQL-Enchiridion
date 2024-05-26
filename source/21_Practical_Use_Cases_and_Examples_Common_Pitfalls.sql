/*********************************************/
/*                                           */
/*  Chapter 21: Practical Use Cases and Examples: Common Pitfalls */
/*                                           */
/*********************************************/

/*********************************************/
/*              Introduction                 */
/*********************************************/

-- This chapter covers practical use cases and common pitfalls in MySQL.
-- By understanding these issues and how to avoid them, you can ensure a more efficient and error-free database experience.

/*********************************************/
/*           Common Pitfalls                 */
/*********************************************/

-- 1. **Using SELECT * in Queries**
-- Using SELECT * retrieves all columns from a table, which can lead to unnecessary data retrieval and performance issues.

-- Example: Avoid using SELECT *
-- Inefficient query
SELECT * FROM employees;

-- Efficient query (select only necessary columns)
SELECT first_name, last_name, department_id FROM employees;

/*********************************************/
/*        2. **Not Using Indexes Properly**  */
/*********************************************/

-- Not using indexes or using them improperly can lead to slow query performance.

-- Example: Missing Index
-- Inefficient query (missing index on last_name)
SELECT * FROM employees WHERE last_name = 'Smith';

-- Adding an index on last_name
CREATE INDEX idx_last_name ON employees(last_name);

-- Efficient query (with index)
SELECT * FROM employees WHERE last_name = 'Smith';

/*********************************************/
/*        3. **Ignoring Normalization**      */
/*********************************************/

-- Ignoring normalization principles can lead to data redundancy and inconsistency.

-- Example: Unnormalized Table
-- Inefficient design (repeating groups)
CREATE TABLE employees_unnormalized (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department1 VARCHAR(50),
    department2 VARCHAR(50),
    department3 VARCHAR(50)
);

-- Normalized design
CREATE TABLE departments_normalized (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

CREATE TABLE employees_normalized (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments_normalized(department_id)
);

/*********************************************/
/*        4. **Not Handling NULLs Properly** */
/*********************************************/

-- Not handling NULL values properly can lead to unexpected results in queries and calculations.

-- Example: Issues with NULLs
-- Inefficient query (ignoring NULLs)
SELECT first_name, last_name FROM employees WHERE salary > 50000;

-- Efficient query (handling NULLs)
SELECT first_name, last_name FROM employees WHERE salary > 50000 OR salary IS NULL;

/*********************************************/
/*       5. **Improper Use of JOINs**        */
/*********************************************/

-- Improper use of JOINs can lead to performance issues and incorrect results.

-- Example: Improper JOIN
-- Inefficient query (cartesian product)
SELECT * FROM employees, departments;

-- Proper JOIN
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

/*********************************************/
/*     6. **Ignoring Transaction Management** */
/*********************************************/

-- Ignoring transaction management can lead to data inconsistencies and integrity issues.

-- Example: Ignoring Transactions
-- Inefficient approach (no transaction management)
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;

-- Proper transaction management
START TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
COMMIT;

/*********************************************/
/*        7. **Using MyISAM for Transactions** */
/*********************************************/

-- MyISAM does not support transactions, foreign keys, or row-level locking.

-- Example: Using InnoDB for Transactions
-- Inefficient use of MyISAM
CREATE TABLE transactions_myisam (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    amount DECIMAL(10,2)
) ENGINE=MyISAM;

-- Proper use of InnoDB
CREATE TABLE transactions_innodb (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    amount DECIMAL(10,2)
) ENGINE=InnoDB;

/*********************************************/
/*         8. **Not Using Prepared Statements** */
/*********************************************/

-- Not using prepared statements can lead to SQL injection vulnerabilities and performance issues.

-- Example: SQL Injection Vulnerability
-- Inefficient approach
SET @user_id = '1 OR 1=1';
SELECT * FROM users WHERE user_id = @user_id;

-- Proper use of prepared statements
PREPARE stmt FROM 'SELECT * FROM users WHERE user_id = ?';
SET @user_id = 1;
EXECUTE stmt USING @user_id;
DEALLOCATE PREPARE stmt;

/*********************************************/
/*        9. **Not Monitoring Performance**  */
/*********************************************/

-- Not monitoring database performance can lead to unoptimized queries and resource bottlenecks.

-- Example: Using EXPLAIN to Monitor Performance
-- Inefficient query (not analyzed)
SELECT * FROM employees WHERE last_name = 'Smith';

-- Proper analysis using EXPLAIN
EXPLAIN SELECT * FROM employees WHERE last_name = 'Smith';

/*********************************************/
/*        10. **Ignoring Security Best Practices** */
/*********************************************/

-- Ignoring security best practices can lead to data breaches and unauthorized access.

-- Example: Proper Security Measures
-- Inefficient approach (no password)
CREATE USER 'new_user'@'localhost';

-- Proper security approach
CREATE USER 'new_user'@'localhost' IDENTIFIED BY 'strong_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON my_database.* TO 'new_user'@'localhost';
