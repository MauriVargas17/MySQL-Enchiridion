/*********************************************/
/*                                           */
/*              Chapter 12: Views            */
/*                                           */
/*********************************************/

/*********************************************/
/*              Introduction                 */
/*********************************************/

-- A view is a virtual table based on the result set of an SQL query. It contains rows and columns, just like a real table.
-- Views can simplify complex queries, enhance security by restricting access to specific data, and provide a level of abstraction.

/*********************************************/
/*           Creating Views                  */
/*********************************************/

-- Basic Syntax:
-- CREATE VIEW view_name AS
-- SELECT columns
-- FROM table
-- WHERE conditions;

-- Example: Creating a Simple View
CREATE VIEW employee_view AS
SELECT first_name, last_name, department_id, salary
FROM employees
WHERE department_id = 1;

-- Using the view
SELECT * FROM employee_view;

/*********************************************/
/*           Complex Views                   */
/*********************************************/

-- Example: View with Joins
CREATE VIEW employee_department_view AS
SELECT e.first_name, e.last_name, d.department_name, e.salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- Using the view
SELECT * FROM employee_department_view;

-- Example: View with Aggregation
CREATE VIEW department_salary_summary AS
SELECT department_id, COUNT(*) AS num_employees, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id;

-- Using the view
SELECT * FROM department_salary_summary;

/*********************************************/
/*           Updatable Views                 */
/*********************************************/

-- Updatable views are views that allow you to perform UPDATE, INSERT, and DELETE operations on the view, which affect the base tables.
-- To be updatable, a view must adhere to certain rules, such as not using aggregation or certain joins.

-- Example: Updatable View
CREATE VIEW updatable_employee_view AS
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE department_id = 1;

-- Updating data through the view
UPDATE updatable_employee_view
SET salary = salary * 1.10
WHERE employee_id = 1;

-- Check the updated table
SELECT * FROM employees;

/*********************************************/
/*           Non-Updatable Views             */
/*********************************************/

-- Non-updatable views are views that do not allow UPDATE, INSERT, or DELETE operations.
-- These views typically include aggregations, groupings, or complex joins.

-- Example: Non-Updatable View with Aggregation
CREATE VIEW non_updatable_view AS
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id;

-- Attempting to update data through the view (this will fail)
-- UPDATE non_updatable_view SET avg_salary = avg_salary * 1.10 WHERE department_id = 1;

/*********************************************/
/*           Views with Check Option         */
/*********************************************/

-- The WITH CHECK OPTION clause ensures that all INSERT or UPDATE operations performed on the view adhere to the view's WHERE clause.

-- Example: View with Check Option
CREATE VIEW employee_view_with_check AS
SELECT first_name, last_name, department_id
FROM employees
WHERE department_id = 1
WITH CHECK OPTION;

-- Attempting to insert data that does not conform to the view's WHERE clause (this will fail)
-- INSERT INTO employee_view_with_check (first_name, last_name, department_id) VALUES ('New', 'Employee', 2);

/*********************************************/
/*           Views with Security Context     */
/*********************************************/

-- Views can be created with a specific security context to control how the view accesses data.
-- There are two options: DEFINER and INVOKER.

-- DEFINER: The view executes with the privileges of the user who defined it.
-- INVOKER: The view executes with the privileges of the user who invokes it.

-- Example: View with Security Context
-- ////////////////// IT DOES NOT WORK YET //////////////////////////////
CREATE VIEW secure_employee_view
SQL SECURITY DEFINER
AS
SELECT first_name, last_name, department_id, salary
FROM employees;

-- Using the view
SELECT * FROM secure_employee_view;
-- ////////////////////////// NEEDS TO BE FIX /////////////////////////////

/*********************************************/
/*           Managing Views                  */
/*********************************************/

-- Altering a View
-- MySQL does not support ALTER VIEW directly. You need to use CREATE OR REPLACE VIEW.

-- Example: Altering a View
CREATE OR REPLACE VIEW employee_view AS
SELECT first_name, last_name, department_id, salary
FROM employees
WHERE department_id = 2;

-- Dropping a View
DROP VIEW IF EXISTS employee_view;

-- Listing All Views
SHOW FULL TABLES IN your_database_name WHERE TABLE_TYPE LIKE 'VIEW';

-- Viewing View Definition
SHOW CREATE VIEW employee_view;

/*********************************************/
/*           Best Practices                  */
/*********************************************/

-- Best Practices for Using Views:
-- 1. Use views to simplify complex queries and make them more readable.
-- 2. Use views to enhance security by restricting access to specific columns or rows.
-- 3. Use the WITH CHECK OPTION clause to ensure data integrity when updating views.
-- 4. Regularly review and optimize views for performance.
-- 5. Document your views with comments to ensure maintainability.
-- 6. Test views thoroughly to ensure they work as expected.
