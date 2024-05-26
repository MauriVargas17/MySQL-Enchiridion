/*********************************************/
/*                                           */
/* Chapter 4: Data Control Language (DCL)    */
/*                                           */
/*********************************************/

-- DCL (Data Control Language): GRANT, REVOKE
-- DCL statements are used to control access to data in the database. They handle permissions and access rights.

/*********************************************/
/*        GRANT Statements                   */
/*********************************************/

-- 	Create a new user
CREATE USER 'username'@'127.0.0.1' IDENTIFIED BY 'password';

-- Grant all privileges on a database to a user
GRANT ALL PRIVILEGES ON database_name.*
TO 'username'@'127.0.0.1' -- Grants all privileges on the specified database to the user

-- Grant specific privileges on a table to a user
GRANT SELECT, INSERT, UPDATE, DELETE
ON database_name.table_name
TO 'username'@'127.0.0.1';  -- Grants specific privileges on the specified table to the user

-- Grant specific privileges on all tables in a database to a user
GRANT SELECT, INSERT, UPDATE, DELETE
ON database_name.*
TO 'username'@'127.0.0.1';  -- Grants specific privileges on all tables in the specified database to the user

-- Grant EXECUTE privilege on a stored procedure to a user
GRANT EXECUTE ON PROCEDURE database_name.procedure_name
TO 'username'@'127.0.0.1';  -- Grants EXECUTE privilege on the specified procedure to the user

-- Grant privileges with GRANT OPTION (allows the user to grant the same privileges to others)
GRANT SELECT, INSERT
ON database_name.table_name
TO 'username'@'127.0.0.1'
WITH GRANT OPTION;  -- Grants privileges with the ability to grant them to others

/*********************************************/
/*        REVOKE Statements                  */
/*********************************************/

-- Revoke all privileges on a database from a user
REVOKE ALL PRIVILEGES, GRANT OPTION
ON database_name.*
FROM 'username'@'127.0.0.1';  -- Revokes all privileges on the specified database from the user

-- Revoke specific privileges on a table from a user
REVOKE SELECT, INSERT, UPDATE, DELETE
ON database_name.table_name
FROM 'username'@'127.0.0.1';  -- Revokes specific privileges on the specified table from the user

-- Revoke EXECUTE privilege on a stored procedure from a user
REVOKE EXECUTE ON PROCEDURE database_name.procedure_name
FROM 'username'@'127.0.0.1';  -- Revokes EXECUTE privilege on the specified procedure from the user

/*********************************************/
/*        User Management                    */
/*********************************************/

-- Create a new user
CREATE USER 'username'@'127.0.0.1' IDENTIFIED BY 'password';  -- Creates a new user with the specified password

-- Drop a user
DROP USER 'username'@'127.0.0.1';  -- Deletes the specified user

-- Rename a user
RENAME USER 'old_username'@'127.0.0.1' TO 'new_username'@'127.0.0.1';  -- Renames the specified user

-- Change a user's password
ALTER USER 'username'@'127.0.0.1' IDENTIFIED BY 'new_password';  -- Changes the password for the specified user

-- Show grants for a user
SHOW GRANTS FOR 'username'@'127.0.0.1';  -- Displays the privileges granted to the specified user

-- The mysql.user table contains information about MySQL user accounts.
-- To query this table, you typically need administrative privileges.

-- Query to get all user accounts and their details
SELECT * FROM mysql.username;

/*********************************************/
/*        Role Management (MySQL 8.0+)       */
/*********************************************/

-- Create a new role
CREATE ROLE 'role_name';  -- Creates a new role

-- Drop a role
DROP ROLE 'role_name';  -- Deletes the specified role

-- Grant privileges to a role
GRANT SELECT, INSERT
ON database_name.table_name
TO 'role_name';  -- Grants specified privileges to the role

-- Grant a role to a user
GRANT 'role_name'
TO 'username'@'127.0.0.1';  -- Grants the specified role to the user

-- Revoke a role from a user
REVOKE 'role_name'
FROM 'username'@'127.0.0.1';  -- Revokes the specified role from the user

-- Show roles granted to a user
SHOW GRANTS FOR 'username'@'127.0.0.1';  -- Displays the roles granted to the specified user

-- Show all roles
SELECT * FROM information_schema.applicable_roles;  -- Lists all roles and their granted privileges
