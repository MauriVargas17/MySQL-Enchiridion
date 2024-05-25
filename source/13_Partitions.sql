/*********************************************/
/*                                           */
/*          Chapter 13: Partitions           */
/*                                           */
/*********************************************/

/*********************************************/
/*              Introduction                 */
/*********************************************/

-- Partitioning is a method of dividing a large table into smaller, more manageable pieces, 
-- while still allowing access to the entire table as a single unit. 
-- Partitioning can improve performance, manageability, and availability.

-- Types of Partitioning:
-- 1. Range Partitioning
-- 2. List Partitioning
-- 3. Hash Partitioning
-- 4. Key Partitioning
-- 5. Composite Partitioning (Subpartitioning)

/*********************************************/
/*           Range Partitioning              */
/*********************************************/

-- Range partitioning assigns rows to partitions based on column values falling within a specified range.

-- Example: Range Partitioning
DROP TABLE IF EXISTS employees_range;
CREATE TABLE employees_range (
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

-- Insert dummy data into the employees_range table
INSERT INTO employees_range (employee_id, first_name, last_name, department_id, salary, hire_date) VALUES
(1, 'John', 'Doe', 1, 60000, '1999-05-15'),
(2, 'Jane', 'Smith', 1, 65000, '2005-08-23'),
(3, 'Jim', 'Brown', 2, 70000, '2015-12-01'),
(4, 'Jake', 'White', 2, 72000, '2018-03-14'),
(5, 'Jill', 'Green', 1, 80000, '2021-07-19');

/*********************************************/
/*           List Partitioning               */
/*********************************************/

-- List partitioning assigns rows to partitions based on column values matching one of a set of discrete values.

-- Example: List Partitioning
DROP TABLE IF EXISTS employees_list;
CREATE TABLE employees_list (
    employee_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_id INT,
    salary DECIMAL(10,2),
    location VARCHAR(50),
    PRIMARY KEY (employee_id, location)
)
PARTITION BY LIST (location) (
    PARTITION pNorth VALUES IN ('New York', 'Boston', 'Chicago'),
    PARTITION pSouth VALUES IN ('Houston', 'Dallas', 'Miami'),
    PARTITION pWest VALUES IN ('San Francisco', 'Los Angeles', 'Seattle')
);

/*********************************************/
/*           Hash Partitioning               */
/*********************************************/

-- Hash partitioning assigns rows to partitions based on a hash function.

-- Example: Hash Partitioning
DROP TABLE IF EXISTS employees_hash;
CREATE TABLE employees_hash (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_id INT,
    salary DECIMAL(10,2)
)
PARTITION BY HASH (department_id) PARTITIONS 4;

/*********************************************/
/*           Key Partitioning                */
/*********************************************/

-- Key partitioning is similar to hash partitioning, but MySQL automatically generates the hash value.

-- Example: Key Partitioning
DROP TABLE IF EXISTS employees_key;
CREATE TABLE employees_key (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_id INT,
    salary DECIMAL(10,2)
)
PARTITION BY KEY(department_id) PARTITIONS 4;

/*********************************************/
/*           Composite Partitioning          */
/*********************************************/

-- Composite partitioning involves using a combination of partitioning methods, such as range partitioning with subpartitioning by hash.

-- Example: Composite Partitioning
DROP TABLE IF EXISTS employees_composite;
CREATE TABLE employees_composite (
    employee_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    PRIMARY KEY (employee_id, hire_date)
)
PARTITION BY RANGE (YEAR(hire_date))
SUBPARTITION BY HASH(department_id) SUBPARTITIONS 4 (
    PARTITION p0 VALUES LESS THAN (2000),
    PARTITION p1 VALUES LESS THAN (2010),
    PARTITION p2 VALUES LESS THAN (2020),
    PARTITION p3 VALUES LESS THAN MAXVALUE
);

/*********************************************/
/*           Handling Foreign Keys           */
/*********************************************/

-- MySQL does not support foreign keys on partitioned tables directly.
-- To use partitioning with foreign keys, you need to create a partitioned table without foreign keys
-- and manage referential integrity manually or use triggers.

-- Example: Creating a Partitioned Table without Foreign Keys
DROP TABLE IF EXISTS employees_no_fk;
CREATE TABLE employees_no_fk (
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

-- Example: Original Table with Foreign Keys
DROP TABLE IF EXISTS employees_fk;
CREATE TABLE employees_fk (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

/*********************************************/
/*           Managing Partitions             */
/*********************************************/

-- Adding a New Partition
ALTER TABLE employees_range ADD PARTITION (
    PARTITION p4 VALUES LESS THAN (2030)
);

-- Dropping a Partition
ALTER TABLE employees_range DROP PARTITION p4;

-- Reorganizing Partitions
ALTER TABLE employees_range REORGANIZE PARTITION p1, p2 INTO (
    PARTITION p1 VALUES LESS THAN (2005),
    PARTITION p2 VALUES LESS THAN (2015)
);

-- Listing Partitions
SHOW CREATE TABLE employees_range;

/*********************************************/
/*           Best Practices                  */
/*********************************************/

-- Best Practices for Using Partitions:
-- 1. Use partitioning to improve query performance and manage large tables.
-- 2. Choose the appropriate partitioning method based on your data and query patterns.
-- 3. Regularly monitor and maintain partitions to ensure optimal performance.
-- 4. Avoid using foreign keys directly on partitioned tables; manage referential integrity manually or use triggers.
-- 5. Document partitioning schemes and their purposes for better maintainability.
-- 6. Test partitioning schemes thoroughly to ensure they meet performance and manageability requirements.
