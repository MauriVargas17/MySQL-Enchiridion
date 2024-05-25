/*****************************************************/
/*                                                   */
/* Chapter 20: Auditing and Monitoring User Activity */
/*                                                   */
/*****************************************************/

/*********************************************/
/*              Introduction                 */
/*********************************************/

-- Auditing and monitoring user activity in MySQL is crucial for security, compliance, and performance tuning.
-- It involves tracking and logging user actions and queries to detect suspicious behavior, ensure compliance, and optimize performance.

/*********************************************/
/*           MySQL Enterprise Audit          */
/*********************************************/

-- MySQL Enterprise Audit provides advanced auditing capabilities to log database activities.
-- It is available with MySQL Enterprise Edition.

-- Example: Enabling MySQL Enterprise Audit
-- Step 1: Install the audit log plugin
INSTALL PLUGIN audit_log SONAME 'audit_log.so';

-- Step 2: Verify the plugin installation
SHOW PLUGINS LIKE 'audit%';

-- Step 3: Configure the audit log settings in the MySQL configuration file (my.cnf or my.ini)
/*
[mysqld]
audit_log_policy = LOGINS
audit_log_format = JSON
audit_log_file = /var/log/mysql/audit.log
*/

-- Step 4: Restart the MySQL server to apply changes

-- Step 5: Query the audit log
SELECT * FROM mysql.audit_log;

/*********************************************/
/*              General Log                  */
/*********************************************/

-- The general log records all SQL queries received by the server.
-- It is useful for debugging and auditing purposes.

-- Example: Enabling the General Log
-- Step 1: Enable the general log in the MySQL configuration file (my.cnf or my.ini)
/*
[mysqld]
general_log = 1
general_log_file = /var/log/mysql/general.log
*/

-- Step 2: Restart the MySQL server to apply changes

-- Step 3: View the general log
-- The general log can be read directly from the file or by querying the log tables if the log_output is set to TABLE.

-- Example: Querying the General Log
-- Enable logging to table
SET GLOBAL log_output = 'TABLE';
SET GLOBAL general_log = 'ON';

-- Query the general_log table
SELECT * FROM mysql.general_log;

/*********************************************/
/*         Performance Schema                */
/*********************************************/

-- The Performance Schema provides a way to inspect the internal execution of the server at runtime.
-- It offers a variety of tables to monitor user activity, query performance, and server metrics.

-- Example: Enabling the Performance Schema
-- Step 1: Enable the Performance Schema in the MySQL configuration file (my.cnf or my.ini)
/*
[mysqld]
performance_schema = ON
*/

-- Step 2: Restart the MySQL server to apply changes

-- Step 3: Query Performance Schema tables
-- Example: Monitoring user activity
SELECT * FROM performance_schema.threads;
SELECT * FROM performance_schema.events_statements_summary_by_user_by_event_name;

/*********************************************/
/*           Slow Query Log                  */
/*********************************************/

-- The Slow Query Log helps in identifying queries that take a long time to execute.
-- It is useful for performance tuning and detecting problematic queries.

-- Example: Enabling the Slow Query Log
-- Step 1: Enable the slow query log in the MySQL configuration file (my.cnf or my.ini)
/*
[mysqld]
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow-query.log
long_query_time = 2
*/

-- Step 2: Restart the MySQL server to apply changes

-- Step 3: View the slow query log
-- The slow query log can be read directly from the file or by querying the log tables if the log_output is set to TABLE.

-- Example: Querying the Slow Query Log
-- Enable logging to table
SET GLOBAL log_output = 'TABLE';
SET GLOBAL slow_query_log = 'ON';

-- Query the slow_log table
SELECT * FROM mysql.slow_log;

/*********************************************/
/*           User Activity Monitoring        */
/*********************************************/

-- Monitoring user activity involves tracking user logins, queries, and changes to the database.

-- Example: Tracking User Logins
-- Use the audit log or the general log to track user logins
SELECT * FROM mysql.audit_log WHERE action = 'login';
SELECT * FROM mysql.general_log WHERE command_type = 'Connect';

-- Example: Monitoring Changes to the Database
-- Use the binary log to track changes to the database
SHOW BINARY LOGS;
SHOW BINLOG EVENTS IN 'mysql-bin.000001';

/*********************************************/
/*           Best Practices                  */
/*********************************************/

-- Best Practices for Auditing and Monitoring:
-- 1. Regularly review logs and audit trails to detect suspicious behavior.
-- 2. Use MySQL Enterprise Audit for advanced auditing capabilities.
-- 3. Enable and configure the general log and slow query log to monitor queries.
-- 4. Use the Performance Schema to gain insights into query performance and server metrics.
-- 5. Monitor user logins and track changes to the database using logs and binary logs.
-- 6. Ensure that logs are securely stored and access to them is restricted.
-- 7. Automate log rotation and archiving to manage log file sizes and retention.

/*********************************************/
/*           Example Setup                   */
/*********************************************/

-- Example: Setting Up Comprehensive Auditing and Monitoring
-- Step 1: Enable the general log
SET GLOBAL general_log = 'ON';
SET GLOBAL general_log_file = '/var/log/mysql/general.log';

-- Step 2: Enable the slow query log
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL slow_query_log_file = '/var/log/mysql/slow-query.log';
SET GLOBAL long_query_time = 2;

-- Step 3: Enable the Performance Schema
-- Add the following to my.cnf or my.ini and restart MySQL
/*
[mysqld]
performance_schema = ON
*/

-- Step 4: Enable MySQL Enterprise Audit (if using MySQL Enterprise Edition)
INSTALL PLUGIN audit_log SONAME 'audit_log.so';

-- Step 5: Review logs and audit trails regularly
SELECT * FROM mysql.general_log;
SELECT * FROM mysql.slow_log;
SELECT * FROM performance_schema.events_statements_summary_by_user_by_event_name;
SELECT * FROM mysql.audit_log;
