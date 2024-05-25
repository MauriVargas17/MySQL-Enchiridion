/*********************************************/
/*                                           */
/*     Chapter 3: Data Query Language (DQL)  */
/*                                           */
/*********************************************/

/*********************************************/
/*              Introduction                 */
/*********************************************/

-- Data Query Language (DQL) is used to query and retrieve data from databases. 
-- The primary command in DQL is SELECT, which is used to specify and retrieve data.
-- DQL is essential for extracting information from databases for reporting and analysis purposes.

/*********************************************/
/*              Basic Queries                */
/*********************************************/

-- Query all columns from a table
SELECT * FROM employees;

-- Query specific columns from a table
SELECT first_name, last_name FROM employees;

-- Query with a WHERE clause to filter rows
SELECT first_name, last_name FROM employees WHERE department_id = 1;

-- Query distinct rows
SELECT DISTINCT department_id FROM employees;

/*********************************************/
/*              Filtering Data               */
/*********************************************/

-- Filtering on numeric columns
SELECT * FROM employees WHERE employee_id >= 10;

-- Filtering on text columns using LIKE
SELECT * FROM employees WHERE last_name LIKE 'S%';

-- Filtering with multiple conditions using AND/OR
SELECT * FROM employees WHERE department_id = 1 AND hire_date > '2020-01-01';
SELECT * FROM employees WHERE department_id = 1 OR department_id = 2;

/*********************************************/
/*              Sorting Data                 */
/*********************************************/

-- Sort the result set in ascending order
SELECT first_name, last_name FROM employees ORDER BY last_name ASC;

-- Sort the result set in descending order
SELECT first_name, last_name FROM employees ORDER BY last_name DESC;

/*********************************************/
/*              Limiting Data                */
/*********************************************/

-- Limit the number of rows returned
SELECT first_name, last_name FROM employees LIMIT 10;

-- Skip a specific number of rows and return the next set of rows
SELECT first_name, last_name FROM employees ORDER BY hire_date DESC LIMIT 10 OFFSET 20;

/*********************************************/
/*              Aggregating Data             */
/*********************************************/

-- Count the number of rows
SELECT COUNT(*) AS total_employees FROM employees;

-- Get the average value of a column
SELECT AVG(salary) AS average_salary FROM employees;

-- Get the sum of a column
SELECT SUM(salary) AS total_salary FROM employees;

-- Get the minimum value of a column
SELECT MIN(hire_date) AS earliest_hire_date FROM employees;

-- Get the maximum value of a column
SELECT MAX(hire_date) AS latest_hire_date FROM employees;

/*********************************************/
/*              Grouping Data                */
/*********************************************/

-- Group rows using an aggregate function
SELECT department_id, COUNT(*) AS num_employees 
FROM employees 
GROUP BY department_id;

-- Filtering groups using HAVING clause
SELECT department_id, COUNT(*) AS num_employees 
FROM employees 
GROUP BY department_id 
HAVING COUNT(*) > 5;

/*********************************************/
/*              Joining Tables               */
/*********************************************/

-- Inner join
SELECT e.first_name, e.last_name, d.department_name 
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;

-- Left join
SELECT e.first_name, e.last_name, d.department_name 
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;

-- Right join
SELECT e.first_name, e.last_name, d.department_name 
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;

-- Full outer join (not directly supported in MySQL, simulated with UNION)
SELECT e.first_name, e.last_name, d.department_name 
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
UNION
SELECT e.first_name, e.last_name, d.department_name 
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;

/*********************************************/
/*              Set Operations               */
/*********************************************/

-- Union
SELECT first_name, last_name FROM employees 
UNION 
SELECT first_name, last_name FROM managers;

-- Union All
SELECT first_name, last_name FROM employees 
UNION ALL
SELECT first_name, last_name FROM managers;

-- Intersect (not directly supported in MySQL, simulated with INNER JOIN)
SELECT first_name, last_name FROM employees 
INNER JOIN managers USING (first_name, last_name);

-- Minus (not directly supported in MySQL, simulated with LEFT JOIN and WHERE clause)
SELECT e.first_name, e.last_name FROM employees e
LEFT JOIN managers m USING (first_name, last_name)
WHERE m.first_name IS NULL;

/*********************************************/
/*           Subqueries and Nested Queries   */
/*********************************************/

-- Subquery in SELECT
SELECT first_name, last_name, 
       (SELECT department_name FROM departments WHERE department_id = e.department_id) AS department_name 
FROM employees e;

-- Subquery in WHERE
SELECT first_name, last_name FROM employees 
WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'Sales');

/*********************************************/
/*             Advanced Filtering            */
/*********************************************/

-- Using IN
SELECT first_name, last_name FROM employees 
WHERE department_id IN (SELECT department_id FROM departments WHERE location_id = 1);

-- Using BETWEEN
SELECT first_name, last_name FROM employees 
WHERE hire_date BETWEEN '2020-01-01' AND '2021-01-01';

-- Using IS NULL and IS NOT NULL
SELECT first_name, last_name FROM employees 
WHERE middle_name IS NULL;

SELECT first_name, last_name FROM employees 
WHERE middle_name IS NOT NULL;

/*********************************************/
/*           Pattern Matching                */
/*********************************************/

-- Using LIKE for pattern matching
SELECT first_name, last_name FROM employees 
WHERE last_name LIKE 'S%';

-- Using NOT LIKE for pattern matching
SELECT first_name, last_name FROM employees 
WHERE last_name NOT LIKE 'S%';

/*********************************************/
/*            Case Statements                */
/*********************************************/

-- Using CASE for conditional logic
SELECT first_name, last_name,
       CASE 
           WHEN department_id = 1 THEN 'HR'
           WHEN department_id = 2 THEN 'Sales'
           ELSE 'Other'
       END AS department_name
FROM employees;

/*********************************************/
/*            Window Functions               */
/*********************************************/

-- Using window functions for advanced analytics
SELECT first_name, last_name, salary,
       RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;

SELECT department_id, first_name, last_name, salary,
       AVG(salary) OVER (PARTITION BY department_id) AS avg_department_salary
FROM employees;

-- Create a sample table
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_id INT,
    salary DECIMAL(10, 2)
);

-- Insert sample data
INSERT INTO employees (first_name, last_name, department_id, salary) VALUES
('John', 'Doe', 1, 60000),
('Jane', 'Smith', 1, 65000),
('Jim', 'Brown', 2, 70000),
('Jake', 'White', 2, 72000),
('Jill', 'Green', 1, 80000);

-- Using ROW_NUMBER() to assign a unique number to each row within a partition
SELECT employee_id, first_name, last_name, department_id, salary,
       ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS row_num
FROM employees;

-- Using RANK() to assign a rank to each row within a partition
SELECT employee_id, first_name, last_name, department_id, salary,
       RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rank
FROM employees;

-- Using DENSE_RANK() to assign a dense rank to each row within a partition
SELECT employee_id, first_name, last_name, department_id, salary,
       DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS dense_rank
FROM employees;

-- Using SUM() to calculate a running total of salaries within a partition
SELECT employee_id, first_name, last_name, department_id, salary,
       SUM(salary) OVER (PARTITION BY department_id ORDER BY salary) AS running_total
FROM employees;

-- Using LAG() to access data from the previous row within the same result set
SELECT employee_id, first_name, last_name, department_id, salary,
       LAG(salary, 1, 0) OVER (PARTITION BY department_id ORDER BY salary) AS previous_salary
FROM employees;

-- Using LEAD() to access data from the next row within the same result set
SELECT employee_id, first_name, last_name, department_id, salary,
       LEAD(salary, 1, 0) OVER (PARTITION BY department_id ORDER BY salary) AS next_salary
FROM employees;

-- Using FIRST_VALUE() to return the first value in the window frame
SELECT employee_id, first_name, last_name, department_id, salary,
       FIRST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY salary) AS first_salary
FROM employees;

-- Using LAST_VALUE() to return the last value in the window frame
SELECT employee_id, first_name, last_name, department_id, salary,
       LAST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY salary) AS last_salary
FROM employees;
