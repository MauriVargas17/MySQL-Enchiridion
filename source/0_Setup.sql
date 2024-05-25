-- Create the database if it does not exist and use it
CREATE DATABASE IF NOT EXISTS my_database;
USE my_database;

-- Create the employees table
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    full_name VARCHAR(100),
    department_id INT,
    salary DECIMAL(10,2),
    bonus DECIMAL(10,2),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Insert dummy data into the employees table
INSERT INTO employees (first_name, last_name, department_id, salary, created_at, updated_at) VALUES
('John', 'Doe', 1, 60000, NOW(), NOW()),
('Jane', 'Smith', 1, 65000, NOW(), NOW()),
('Jim', 'Brown', 2, 70000, NOW(), NOW()),
('Jake', 'White', 2, 72000, NOW(), NOW()),
('Jill', 'Green', 1, 80000, NOW(), NOW());

-- Create the departments table
DROP TABLE IF EXISTS departments;
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(50),
    location_id INT
);

-- Insert dummy data into the departments table
INSERT INTO departments (department_name, location_id) VALUES
('Human Resources', 1),
('Sales', 2),
('Engineering', 3);

-- Create the audit_log table
DROP TABLE IF EXISTS audit_log;
CREATE TABLE audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    operation VARCHAR(50),
    operation_date DATETIME,
    employee_id INT
);

-- Insert dummy data into the audit_log table (example, usually filled by triggers)
INSERT INTO audit_log (operation, operation_date, employee_id) VALUES
('INSERT', NOW(), 1),
('UPDATE', NOW(), 2),
('DELETE', NOW(), 3);

-- Create the employee_updates_log table for handling updates via triggers
DROP TABLE IF EXISTS employee_updates_log;
CREATE TABLE employee_updates_log (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

-- Insert dummy data into the employee_updates_log table (example, usually filled by triggers)
INSERT INTO employee_updates_log (employee_id, first_name, last_name) VALUES
(1, 'John', 'Doe'),
(2, 'Jane', 'Smith');

-- Ensure all tables are populated correctly
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM audit_log;
SELECT * FROM employee_updates_log;

-- Add any additional necessary data here
