/*********************************************/
/*                                           */
/*          Chapter 15: Database Security    */
/*                                           */
/*********************************************/

/*********************************************/
/*              Introduction                 */
/*********************************************/

-- Database security is the process of protecting the database from unauthorized access, misuse, and threats.
-- It involves implementing measures to ensure the confidentiality, integrity, and availability of the database.

/*********************************************/
/*              User Management              */
/*********************************************/

-- Managing users and their access to the database is fundamental to database security.
-- Create, alter, and drop users using the following commands.

-- Creating a new user
CREATE USER 'new_user'@'localhost' IDENTIFIED BY 'password';

-- Granting privileges to a user
GRANT SELECT, INSERT, UPDATE, DELETE ON database_name.* TO 'new_user'@'localhost';

-- Revoking privileges from a user
REVOKE INSERT, DELETE ON database_name.* FROM 'new_user'@'localhost';

-- Altering a user
ALTER USER 'new_user'@'localhost' IDENTIFIED BY 'new_password';

-- Dropping a user
DROP USER 'new_user'@'localhost';

/*********************************************/
/*              Permissions                  */
/*********************************************/

-- Permissions (or privileges) control what actions a user can perform on the database.
-- Common privileges include SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, and GRANT.

-- Granting all privileges to a user
GRANT ALL PRIVILEGES ON database_name.* TO 'admin_user'@'localhost';

-- Revoking all privileges from a user
REVOKE ALL PRIVILEGES ON database_name.* FROM 'admin_user'@'localhost';

-- Viewing user privileges
SHOW GRANTS FOR 'admin_user'@'localhost';

/*********************************************/
/*              Role Management              */
/*********************************************/

-- Roles are a way to manage and group permissions for multiple users.
-- Creating a role
CREATE ROLE 'read_only';

-- Granting privileges to a role
GRANT SELECT ON database_name.* TO 'read_only';

-- Assigning a role to a user
GRANT 'read_only' TO 'new_user'@'localhost';

-- Revoking a role from a user
REVOKE 'read_only' FROM 'new_user'@'localhost';

/*********************************************/
/*              Encryption                   */
/*********************************************/

-- Encryption helps protect sensitive data by converting it into an unreadable format that can only be decrypted by authorized parties.
-- MySQL supports data-at-rest encryption and SSL/TLS for data-in-transit encryption.

-- Enabling SSL for MySQL (configuration steps)
-- 1. Generate SSL certificates and keys.
-- 2. Configure the MySQL server to use SSL.
-- 3. Require SSL for specific users.

-- Example: Requiring SSL for a user
CREATE USER 'secure_user'@'localhost' IDENTIFIED BY 'secure_password' REQUIRE SSL;
GRANT ALL PRIVILEGES ON secure_database.* TO 'secure_user'@'localhost';

/*********************************************/
/*              Auditing                     */
/*********************************************/

-- Auditing involves tracking and recording database activities to detect and respond to security incidents.
-- MySQL Enterprise Audit provides auditing capabilities.

-- Example: Basic Audit Configuration
-- Install the audit log plugin (requires MySQL Enterprise Edition)
INSTALL PLUGIN audit_log SONAME 'audit_log.so';

-- Configure audit log settings in the MySQL configuration file (my.cnf or my.ini)
[mysqld]
audit-log=FORCE_PLUS_PERMANENT
audit-log-file=/var/log/mysql/audit.log
audit-log-format=JSON

-- Restart the MySQL server to apply changes
-- (Command varies depending on the system, e.g., `sudo systemctl restart mysql`)

/*********************************************/
/*              Best Practices               */
/*********************************************/

-- Best Practices for Database Security:
-- 1. Implement the principle of least privilege (grant only necessary permissions).
-- 2. Use strong, unique passwords for database users.
-- 3. Regularly update and patch the database system to fix vulnerabilities.
-- 4. Enable SSL/TLS to encrypt data in transit.
-- 5. Use encryption to protect sensitive data at rest.
-- 6. Regularly back up the database and securely store backups.
-- 7. Monitor and audit database activities to detect suspicious behavior.
-- 8. Implement firewall rules to restrict access to the database server.
-- 9. Use roles to manage and group user permissions.
-- 10. Regularly review and update security policies and procedures.

/*********************************************/
/*              Example Setup                */
/*********************************************/

-- Example: Secure Database Setup

-- Step 1: Create a new user with limited privileges
CREATE USER 'secure_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT SELECT, INSERT, UPDATE ON secure_database.* TO 'secure_user'@'localhost';

-- Step 2: Enable SSL for the user
CREATE USER 'secure_user'@'localhost' IDENTIFIED BY 'secure_password' REQUIRE SSL;
GRANT ALL PRIVILEGES ON secure_database.* TO 'secure_user'@'localhost';

-- Step 3: Create a role for read-only access and assign it to a user
CREATE ROLE 'read_only';
GRANT SELECT ON secure_database.* TO 'read_only';
CREATE USER 'read_user'@'localhost' IDENTIFIED BY 'read_password';
GRANT 'read_only' TO 'read_user'@'localhost';

-- Step 4: Enable auditing and configure audit settings (requires MySQL Enterprise Edition)
INSTALL PLUGIN audit_log SONAME 'audit_log.so';
-- Configure audit log settings in the MySQL configuration file (my.cnf or my.ini)
/*
[mysqld]
audit-log=FORCE_PLUS_PERMANENT
audit-log-file=/var/log/mysql/audit.log
audit-log-format=JSON
*/
-- Restart the MySQL server to apply changes

-- Step 5: Regularly review and update security settings and monitor database activity
SHOW GRANTS FOR 'secure_user'@'localhost';
SHOW GRANTS FOR 'read_user'@'localhost';
