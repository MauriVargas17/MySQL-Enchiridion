/*********************************************/
/*                                           */
/*           Chapter 16: Query Optimization  */
/*                                           */
/*********************************************/

/*********************************************/
/*              Introduction                 */
/*********************************************/

-- Query optimization is the process of enhancing the performance of SQL queries.
-- It involves improving query execution times and resource usage through various techniques and best practices.

/*********************************************/
/*          Indexing Strategies              */
/*********************************************/

-- Indexes are critical for speeding up data retrieval. Proper indexing can significantly improve query performance.
-- Types of Indexes:
-- 1. Single-column Index
-- 2. Composite Index
-- 3. Unique Index
-- 4. Full-text Index
-- 5. Covering Index

-- Example: Creating Indexes
CREATE INDEX idx_employee_last_name ON employees (last_name);
CREATE UNIQUE INDEX idx_employee_email ON employees (email);
CREATE FULLTEXT INDEX idx_employee_fulltext ON employees (first_name, last_name);

-- Covering Index: An index that includes all the columns needed by a query.
-- Example: Covering Index
CREATE INDEX idx_employee_covering ON employees (last_name, first_name, salary);

/*********************************************/
/*          Writing Efficient Queries        */
/*********************************************/

-- Writing efficient SQL queries is essential for optimal performance.
-- Techniques:
-- 1. Select only necessary columns
-- 2. Avoid using SELECT *
-- 3. Use WHERE clauses to filter data early
-- 4. Avoid unnecessary joins
-- 5. Use LIMIT to restrict the number of rows returned

-- Example: Selecting Necessary Columns
SELECT first_name, last_name FROM employees WHERE department_id = 1;

-- Example: Using WHERE Clause
SELECT first_name, last_name FROM employees WHERE salary > 50000;

-- Example: Using LIMIT
SELECT first_name, last_name FROM employees WHERE department_id = 1 LIMIT 10;

/*********************************************/
/*          Analyzing Query Execution Plans  */
/*********************************************/

-- The EXPLAIN statement provides information about how MySQL executes a query.
-- Use EXPLAIN to analyze query execution plans and identify performance bottlenecks.

-- Example: Using EXPLAIN
EXPLAIN SELECT first_name, last_name FROM employees WHERE department_id = 1;

-- Output of EXPLAIN includes important information like:
-- 1. id: The select identifier
-- 2. select_type: The type of select
-- 3. table: The table for the output row
-- 4. type: The join type
-- 5. possible_keys: The possible indexes to choose
-- 6. key: The index actually chosen
-- 7. key_len: The length of the chosen key
-- 8. ref: The columns compared to the index
-- 9. rows: The number of rows MySQL estimates it must read to find the needed data
-- 10. Extra: Additional information about the query execution

/*********************************************/
/*          Optimizing Joins                 */
/*********************************************/

-- Joins are often a source of performance issues. Optimizing joins can significantly improve query performance.
-- Techniques:
-- 1. Use appropriate join types (INNER JOIN, LEFT JOIN, etc.)
-- 2. Ensure join columns are indexed
-- 3. Use small result sets in join conditions

-- Example: Optimized Join
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > 50000;

/*********************************************/
/*          Optimizing Subqueries            */
/*********************************************/

-- Subqueries can be optimized by rewriting them as joins or using derived tables.
-- Techniques:
-- 1. Avoid using correlated subqueries if possible
-- 2. Use derived tables or common table expressions (CTEs)

-- Example: Optimizing Subqueries with Joins
-- Original subquery
SELECT first_name, last_name
FROM employees
WHERE department_id IN (SELECT department_id FROM departments WHERE location = 'New York');

-- Optimized with join
SELECT e.first_name, e.last_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.location = 'New York';

/*********************************************/
/*          Caching and Materialized Views   */
/*********************************************/

-- Caching frequently accessed data and using materialized views can improve query performance.
-- Techniques:
-- 1. Use query caching
-- 2. Create materialized views for complex queries

-- Example: Creating a Materialized View (Using a table to simulate materialized view)
CREATE TABLE employee_salary_summary AS
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id;

/*********************************************/
/*          Partitioning                     */
/*********************************************/

-- Partitioning a table can improve query performance by dividing the table into smaller, more manageable pieces.
-- Types of Partitioning:
-- 1. Range Partitioning
-- 2. List Partitioning
-- 3. Hash Partitioning
-- 4. Key Partitioning

-- Example: Range Partitioning
CREATE TABLE employees_partitioned (
    employee_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    PRIMARY KEY (employee_id, hire_date)
)
PARTITION BY RANGE (YEAR(hire_date)) (
    PARTITION p0 VALUES LESS THAN (2000),
    PARTITION p1 VALUES LESS THAN (2010),
    PARTITION p2 VALUES LESS THAN (2020),
    PARTITION p3 VALUES LESS THAN MAXVALUE
);

/*********************************************/
/*          Managing Database Connections    */
/*********************************************/

-- Managing database connections efficiently can improve performance.
-- Techniques:
-- 1. Use connection pooling
-- 2. Close unused connections
-- 3. Optimize connection settings

-- Example: Configuring Connection Pooling (Configuration steps for the application)
/*
[database]
host = "localhost"
port = 3306
user = "db_user"
password = "db_password"
database = "my_database"
pool_size = 10
*/

/*********************************************/
/*          Best Practices                   */
/*********************************************/

-- Best Practices for Query Optimization:
-- 1. Use indexes to speed up data retrieval.
-- 2. Write efficient queries by selecting only necessary columns and using WHERE clauses.
-- 3. Analyze query execution plans using EXPLAIN.
-- 4. Optimize joins by ensuring join columns are indexed.
-- 5. Rewrite subqueries as joins or use derived tables to improve performance.
-- 6. Use caching and materialized views for frequently accessed data.
-- 7. Partition large tables to improve manageability and performance.
-- 8. Manage database connections efficiently to reduce overhead.
-- 9. Regularly monitor and tune the database to maintain optimal performance.

/*********************************************/
/*          Example Optimization             */
/*********************************************/

-- Example: Optimizing a Complex Query
-- Original query with subquery and no indexing
EXPLAIN SELECT first_name, last_name
FROM employees
WHERE department_id IN (SELECT department_id FROM departments WHERE location = 'New York');

-- Optimized query with join and indexing
CREATE INDEX idx_department_location ON departments (location);
EXPLAIN SELECT e.first_name, e.last_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.location = 'New York';
