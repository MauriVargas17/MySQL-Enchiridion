/*********************************************/
/*                                           */
/*          Chapter 8: Indexes               */
/*                                           */
/*********************************************/

/*********************************************/
/*              Introduction                 */
/*********************************************/

-- Indexes are used to speed up the retrieval of rows by using a pointer. They improve the performance of SELECT queries
-- but can slow down INSERT, UPDATE, and DELETE operations because the index must also be updated. Indexes can be created 
-- on one or more columns of a table, and they are critical for query optimization.

-- Basic Syntax:
-- CREATE INDEX index_name ON table_name (column1, column2, ...);

-- DROP INDEX index_name ON table_name;

/*********************************************/
/*              Types of Indexes             */
/*********************************************/

-- There are several types of indexes in MySQL:

-- 1. Single-Column Indexes
-- 2. Composite Indexes (Multi-Column Indexes)
-- 3. Unique Indexes
-- 4. Full-Text Indexes
-- 5. Spatial Indexes (used with spatial data types)

-- 1. Single-Column Indexes:
-- Create an index on a single column.
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    last_name VARCHAR(50),
    first_name VARCHAR(50),
    department_id INT
);

CREATE INDEX idx_last_name ON employees (last_name);  -- Creates an index on the last_name column

-- 2. Composite Indexes:
-- Create an index on multiple columns. Useful when queries often filter by more than one column.
CREATE INDEX idx_name_department ON employees (last_name, department_id);  -- Creates a composite index on last_name and department_id

-- 3. Unique Indexes:
-- Ensures that all values in the indexed column(s) are unique.
CREATE UNIQUE INDEX idx_unique_last_name ON employees (last_name);  -- Creates a unique index

-- 4. Full-Text Indexes:
-- Used for full-text searches. Only supported with InnoDB and MyISAM storage engines.
CREATE TABLE articles (
    article_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    body TEXT,
    FULLTEXT (title, body)
);

-- Example of full-text search:
SELECT * FROM articles
WHERE MATCH(title, body) AGAINST('MySQL Full-Text Search');

/*********************************************/
/*              Managing Indexes             */
/*********************************************/

-- Dropping an Index:
-- To remove an index, use the DROP INDEX statement.
DROP INDEX idx_last_name ON employees;  -- Drops the index on last_name

-- Listing Indexes:
-- To list all indexes on a table, use the SHOW INDEX statement.
SHOW INDEX FROM employees;

/*********************************************/
/*              Performance Considerations   */
/*********************************************/

-- Indexes can significantly improve query performance, but they also come with some trade-offs:
-- 1. Increased Storage: Indexes require additional storage space.
-- 2. Slower Write Operations: INSERT, UPDATE, DELETE operations can be slower because indexes must also be updated.
-- 3. Maintenance: Indexes need to be maintained, which can add overhead during database administration.

-- Example: Index Usage in Queries
-- Indexes are automatically used by the MySQL optimizer to speed up queries. Here is how you can see if an index is being used:
EXPLAIN SELECT * FROM employees WHERE last_name = 'Smith';

-- The EXPLAIN statement provides information about how MySQL executes a query and whether it uses indexes.

/*********************************************/
/*        Special Cases and Modifications    */
/*********************************************/

-- Modifying a Table to Add/Drop an Index
-- You can add or drop an index at any time without modifying the table's structure.

-- Adding an Index:
ALTER TABLE employees ADD INDEX idx_first_name (first_name);  -- Adds an index on the first_name column

-- Dropping an Index:
ALTER TABLE employees DROP INDEX idx_first_name;  -- Drops the index on the first_name column

-- Using Index Hints:
-- Sometimes, you may want to force MySQL to use or ignore a particular index using index hints.
SELECT * FROM employees USE INDEX (idx_last_name) WHERE last_name = 'Smith';
SELECT * FROM employees IGNORE INDEX (idx_last_name) WHERE last_name = 'Smith';

/*********************************************/
/*              Case Studies                 */
/*********************************************/

-- Case Study 1: Improving Query Performance
-- Without Index:
SELECT * FROM employees WHERE last_name = 'Smith';
-- The above query may perform a full table scan if there is no index on last_name.

-- With Index:
CREATE INDEX idx_last_name ON employees (last_name);
SELECT * FROM employees WHERE last_name = 'Smith';
-- The above query uses the index on last_name, significantly improving performance.

-- Case Study 2: Composite Index Usage
-- Without Composite Index:
SELECT * FROM employees WHERE last_name = 'Smith' AND department_id = 1;
-- The above query may perform a full table scan if there is no composite index.

-- With Composite Index:
CREATE INDEX idx_name_dept ON employees (last_name, department_id);
SELECT * FROM employees WHERE last_name = 'Smith' AND department_id = 1;
-- The above query uses the composite index, improving performance.

/*********************************************/
/*              Best Practices               */
/*********************************************/

-- Best Practices for Using Indexes:
-- 1. Index columns that are frequently used in WHERE clauses.
-- 2. Use composite indexes for columns that are often used together in queries.
-- 3. Avoid indexing columns with low cardinality (few unique values).
-- 4. Regularly monitor and maintain indexes to ensure optimal performance.
-- 5. Use the EXPLAIN statement to understand how indexes are being used by queries.
-- 6. Be mindful of the impact of indexes on write operations.
