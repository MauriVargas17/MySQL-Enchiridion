/*********************************************/
/*                                           */
/* Chapter 2: Data Manipulation Language (DML) */
/*                                           */
/*********************************************/

-- DML (Data Manipulation Language): SELECT, INSERT, UPDATE, DELETE
-- DML statements are used to manipulate the data within the database objects. 
-- They handle data retrieval, insertion, updating, and deletion.

/*********************************************/
/*        SELECT Statements                  */
/*********************************************/

-- Basic SELECT
SELECT column1, column2
FROM table_name;

-- SELECT with WHERE Clause
SELECT column1, column2
FROM table_name
WHERE condition;  -- Filters records based on a specified condition

-- SELECT with JOINs
-- INNER JOIN
SELECT a.column1, b.column2
FROM table1 a
INNER JOIN table2 b ON a.common_field = b.common_field;  -- Returns records with matching values in both tables

-- LEFT JOIN
SELECT a.column1, b.column2
FROM table1 a
LEFT JOIN table2 b ON a.common_field = b.common_field;  -- Returns all records from the left table and matched records from the right table

-- RIGHT JOIN
SELECT a.column1, b.column2
FROM table1 a
RIGHT JOIN table2 b ON a.common_field = b.common_field;  -- Returns all records from the right table and matched records from the left table

-- FULL JOIN (not supported by MySQL, can be simulated with UNION)
SELECT a.column1, b.column2
FROM table1 a
LEFT JOIN table2 b ON a.common_field = b.common_field
UNION
SELECT a.column1, b.column2
FROM table1 a
RIGHT JOIN table2 b ON a.common_field = b.common_field;  -- Combines results of both LEFT and RIGHT JOINs

-- SELECT with Subqueries
SELECT column1
FROM table_name
WHERE column2 = (SELECT column2 FROM another_table WHERE condition);  -- Subquery to filter records

-- SELECT with Aggregate Functions
SELECT COUNT(*), AVG(column1), MAX(column1), MIN(column1), SUM(column1)
FROM table_name
WHERE condition;  -- Performs aggregate operations on records

-- SELECT with GROUP BY and HAVING
SELECT column1, COUNT(*)
FROM table_name
GROUP BY column1
HAVING COUNT(*) > 1;  -- Groups records and filters groups based on aggregate conditions

/*********************************************/
/*        INSERT Statements                  */
/*********************************************/

-- Basic INSERT
INSERT INTO table_name (column1, column2)
VALUES (value1, value2);

-- INSERT with SELECT
INSERT INTO table_name (column1, column2)
SELECT column1, column2
FROM another_table
WHERE condition;  -- Inserts records from another table based on a condition

-- INSERT IGNORE and REPLACE
INSERT IGNORE INTO table_name (column1, column2)
VALUES (value1, value2);  -- Ignores insert if duplicate key error occurs

REPLACE INTO table_name (column1, column2)
VALUES (value1, value2);  -- Replaces existing row with new row if duplicate key error occurs

/*********************************************/
/*        UPDATE Statements                  */
/*********************************************/

-- Basic UPDATE
UPDATE table_name
SET column1 = value1, column2 = value2
WHERE condition;  -- Updates records based on a condition

-- UPDATE with Subqueries
UPDATE table_name
SET column1 = (SELECT column2 FROM another_table WHERE condition)
WHERE condition;  -- Updates records based on a subquery

-- UPDATE with Joins
UPDATE table1 a
JOIN table2 b ON a.common_field = b.common_field
SET a.column1 = b.column2
WHERE condition;  -- Updates records based on a join with another table

/*********************************************/
/*        DELETE Statements                  */
/*********************************************/

-- Basic DELETE
DELETE FROM table_name
WHERE condition;  -- Deletes records based on a condition

-- DELETE with Subqueries
DELETE FROM table_name
WHERE column1 = (SELECT column1 FROM another_table WHERE condition);  -- Deletes records based on a subquery
