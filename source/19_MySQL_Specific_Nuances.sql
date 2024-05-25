/*********************************************/
/*                                           */
/*     Chapter 19: MySQL Specific Nuances    */
/*                                           */
/*********************************************/

/*********************************************/
/*              Introduction                 */
/*********************************************/

-- MySQL has several unique features and behaviors that differentiate it from other relational database management systems.
-- Understanding these nuances can help in optimizing performance, managing data, and avoiding common pitfalls.

/*********************************************/
/*           Storage Engines                 */
/*********************************************/

-- MySQL supports multiple storage engines, each with its own features and use cases.
-- The most commonly used storage engines are InnoDB and MyISAM.

-- InnoDB: Supports transactions, foreign keys, and row-level locking. It is the default storage engine.
-- Example: Creating a table with InnoDB
CREATE TABLE example_innodb (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(100)
) ENGINE=InnoDB;

-- MyISAM: Supports table-level locking and fast read operations but does not support transactions or foreign keys.
-- Example: Creating a table with MyISAM
CREATE TABLE example_myisam (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(100)
) ENGINE=MyISAM;

/*********************************************/
/*           Data Types and Functions        */
/*********************************************/

-- MySQL has unique data types and functions that are not present in other SQL databases.

-- JSON Data Type: MySQL supports a native JSON data type for storing JSON documents.
-- Example: Using JSON data type
CREATE TABLE example_json (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data JSON
);

-- JSON Functions: MySQL provides various functions for manipulating JSON data.
-- Example: Extracting data from a JSON document
SELECT JSON_EXTRACT(data, '$.key') FROM example_json;

-- Full-Text Search: MySQL supports full-text search capabilities for MyISAM and InnoDB tables.
-- Example: Creating a full-text index and performing a full-text search
CREATE TABLE example_fulltext (
    id INT AUTO_INCREMENT PRIMARY KEY,
    content TEXT,
    FULLTEXT (content)
);

SELECT * FROM example_fulltext WHERE MATCH(content) AGAINST('search term');

/*********************************************/
/*           Indexing Strategies             */
/*********************************************/

-- MySQL offers unique indexing options and strategies that can be leveraged for performance optimization.

-- Prefix Indexes: Allows indexing a prefix of a string column.
-- Example: Creating a prefix index
CREATE TABLE example_prefix (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(255),
    INDEX (data(100))
);

-- Spatial Indexes: MySQL supports spatial indexes for spatial data types.
-- Example: Creating a spatial index
CREATE TABLE example_spatial (
    id INT AUTO_INCREMENT PRIMARY KEY,
    location POINT,
    SPATIAL INDEX (location)
);

/*********************************************/
/*           Configuration Options           */
/*********************************************/

-- MySQL provides various configuration options that can be tuned for performance, security, and other purposes.

-- Example: Configuring InnoDB Buffer Pool Size
-- The InnoDB buffer pool is a key component for performance optimization.
-- Configure the buffer pool size in the MySQL configuration file (my.cnf or my.ini)
-- innodb_buffer_pool_size = 2G

-- Example: Configuring Query Cache
-- The query cache can improve performance by caching the results of SELECT queries.
-- Enable and configure the query cache in the MySQL configuration file (my.cnf or my.ini)
-- query_cache_type = 1
-- query_cache_size = 64M

/*********************************************/
/*           Special Features                */
/*********************************************/

-- MySQL has several special features that are not commonly found in other RDBMS.

-- AUTO_INCREMENT: MySQL supports the AUTO_INCREMENT attribute for automatically generating unique values.
-- Example: Using AUTO_INCREMENT
CREATE TABLE example_autoincrement (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(100)
);

-- REPLACE INTO: MySQL supports the REPLACE INTO statement, which is a combination of INSERT and DELETE.
-- Example: Using REPLACE INTO
REPLACE INTO example_autoincrement (id, data) VALUES (1, 'new data');

-- ON DUPLICATE KEY UPDATE: MySQL allows updating records if a duplicate key is found during an insert operation.
-- Example: Using ON DUPLICATE KEY UPDATE
INSERT INTO example_autoincrement (id, data) VALUES (1, 'new data')
ON DUPLICATE KEY UPDATE data = 'updated data';

/*********************************************/
/*           Error Handling                  */
/*********************************************/

-- MySQL has specific error codes and messages that can be used to handle errors more effectively.

-- Example: Handling Duplicate Key Error
DELIMITER $$
CREATE PROCEDURE handle_duplicate_key()
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLSTATE '23000'
    BEGIN
        SELECT 'Duplicate key error occurred.' AS error_message;
    END;

    INSERT INTO example_autoincrement (id, data) VALUES (1, 'new data');
END $$
DELIMITER ;

-- Calling the procedure
CALL handle_duplicate_key();

/*********************************************/
/*           Performance Tuning              */
/*********************************************/

-- MySQL offers various performance tuning options and tools.

-- Example: Using the EXPLAIN statement to analyze query performance
EXPLAIN SELECT * FROM example_autoincrement WHERE data = 'example';

-- Example: Using the MySQL Performance Schema
-- The Performance Schema provides a way to inspect the internal execution of the server at runtime.
-- Enable the Performance Schema in the MySQL configuration file (my.cnf or my.ini)
-- performance_schema = ON

-- Example: Analyzing Slow Queries
-- The Slow Query Log helps in identifying queries that take a long time to execute.
-- Enable and configure the Slow Query Log in the MySQL configuration file (my.cnf or my.ini)
-- slow_query_log = 1
-- slow_query_log_file = /var/log/mysql/slow-query.log
-- long_query_time = 2

/*********************************************/
/*           Best Practices                  */
/*********************************************/

-- Best Practices for MySQL Specific Nuances:
-- 1. Choose the appropriate storage engine for your use case (e.g., InnoDB for transactions, MyISAM for read-heavy workloads).
-- 2. Use MySQL-specific data types and functions to take full advantage of MySQL features.
-- 3. Optimize indexing strategies based on query patterns and data distribution.
-- 4. Regularly tune MySQL configuration options to match workload requirements.
-- 5. Leverage MySQL's special features like AUTO_INCREMENT, REPLACE INTO, and ON DUPLICATE KEY UPDATE for efficient data management.
-- 6. Use error handling to gracefully manage common MySQL-specific errors.
-- 7. Continuously monitor and tune performance using tools like EXPLAIN, Performance Schema, and the Slow Query Log.
