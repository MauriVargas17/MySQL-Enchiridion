/*********************************************/
/*                                           */
/*       Chapter 19: Connecting to MySQL     */
/*                                           */
/*********************************************/

/*********************************************/
/*              Introduction                 */
/*********************************************/

-- Connecting to a MySQL instance from the command line allows you to manage databases, run queries, and perform administrative tasks.
-- You can specify various options such as user, host, port, and more to customize your connection.

/*********************************************/
/*            Basic Connection               */
/*********************************************/

-- The basic command to connect to a MySQL instance is `mysql`.
-- Syntax:
-- mysql -u [username] -p

-- Example: Connecting as root user
mysql -u root -p

/*********************************************/
/*            Specifying Host and Port       */
/*********************************************/

-- You can specify the host and port to connect to a remote MySQL server.
-- Syntax:
-- mysql -u [username] -p -h [hostname] -P [port]

-- Example: Connecting to a remote MySQL server
mysql -u root -p -h 192.168.1.100 -P 3306

/*********************************************/
/*            Connecting to a Database       */
/*********************************************/

-- You can specify the database to connect to directly.
-- Syntax:
-- mysql -u [username] -p -h [hostname] -P [port] [database_name]

-- Example: Connecting to a specific database
mysql -u root -p -h 192.168.1.100 -P 3306 my_database

/*********************************************/
/*            Using SSL/TLS                  */
/*********************************************/

-- To secure the connection using SSL/TLS, you can specify SSL-related options.
-- Syntax:
-- mysql -u [username] -p -h [hostname] -P [port] --ssl-ca=[ca-cert.pem] --ssl-cert=[client-cert.pem] --ssl-key=[client-key.pem]

-- Example: Connecting with SSL
mysql -u root -p -h 192.168.1.100 -P 3306 --ssl-ca=/path/to/ca-cert.pem --ssl-cert=/path/to/client-cert.pem --ssl-key=/path/to/client-key.pem

/*********************************************/
/*            Configuring Timeouts           */
/*********************************************/

-- You can configure connection and query timeouts.
-- Syntax:
-- mysql -u [username] -p -h [hostname] -P [port] --connect-timeout=[seconds] --max_allowed_packet=[bytes] --net_read_timeout=[seconds] --net_write_timeout=[seconds]

-- Example: Setting timeouts
mysql -u root -p -h 192.168.1.100 -P 3306 --connect-timeout=10 --max_allowed_packet=64M --net_read_timeout=60 --net_write_timeout=60

/*********************************************/
/*            Using Option Files             */
/*********************************************/

-- You can use option files to store connection parameters securely.
-- Create a `.my.cnf` file in your home directory with the following format:

-- [client]
-- user=[username]
-- password=[password]
-- host=[hostname]
-- port=[port]
-- database=[database_name]

-- Example: Connecting using an option file
mysql --defaults-file=~/.my.cnf

/*********************************************/
/*            Additional Options             */
/*********************************************/

-- Verbose Mode: Provides detailed information about the connection process.
-- Syntax:
-- mysql -u [username] -p -h [hostname] -P [port] --verbose

-- Example: Using verbose mode
mysql -u root -p -h 192.168.1.100 -P 3306 --verbose

-- Silent Mode: Suppresses all output except for errors.
-- Syntax:
-- mysql -u [username] -p -h [hostname] -P [port] --silent

-- Example: Using silent mode
mysql -u root -p -h 192.168.1.100 -P 3306 --silent

-- Batch Mode: Useful for running scripts and commands non-interactively.
-- Syntax:
-- mysql -u [username] -p -h [hostname] -P [port] --batch

-- Example: Using batch mode
mysql -u root -p -h 192.168.1.100 -P 3306 --batch < /path/to/script.sql

/*********************************************/
/*            Examples of Common Commands    */
/*********************************************/

-- Connecting to a local MySQL server
mysql -u root -p

-- Connecting to a remote MySQL server with a specific user
mysql -u admin -p -h db.example.com -P 3306

-- Connecting with SSL/TLS
mysql -u secure_user -p -h secure.example.com -P 3306 --ssl-ca=/path/to/ca-cert.pem --ssl-cert=/path/to/client-cert.pem --ssl-key=/path/to/client-key.pem

-- Connecting using an option file
mysql --defaults-file=~/.my.cnf

-- Connecting and selecting a specific database
mysql -u root -p -h 192.168.1.100 -P 3306 my_database
