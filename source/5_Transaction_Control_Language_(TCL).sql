/**************************************************/
/*                                                */
/*  Chapter 5: Transaction Control Language (TCL) */
/*                                                */
/**************************************************/

-- TCL (Transaction Control Language): COMMIT, ROLLBACK, SAVEPOINT, SET TRANSACTION
-- TCL statements are used to manage transactions in the database. They ensure the integrity of data by grouping a set of operations into a single, atomic unit of work.

/*********************************************/
/*        COMMIT Statement                   */
/*********************************************/

-- COMMIT
-- The COMMIT statement is used to permanently save all changes made during the current transaction.
COMMIT;

/*********************************************/
/*        ROLLBACK Statement                 */
/*********************************************/

-- ROLLBACK
-- The ROLLBACK statement is used to undo all changes made during the current transaction.
ROLLBACK;

/*********************************************/
/*        SAVEPOINT Statement                */
/*********************************************/

-- SAVEPOINT
-- The SAVEPOINT statement sets a point within a transaction to which you can later roll back.
SAVEPOINT savepoint_name;

-- Example:
START TRANSACTION;
UPDATE employees SET hire_date = '2022-01-01' WHERE employee_id = 1;
SAVEPOINT savepoint1;  -- Sets a savepoint named savepoint1
UPDATE employees SET hire_date = '2022-01-02' WHERE employee_id = 2;
ROLLBACK TO savepoint1;  -- Rolls back to savepoint1, undoing the second update
COMMIT;  -- Commits the transaction, saving the first update

/*********************************************/
/*        SET TRANSACTION Statement          */
/*********************************************/

-- SET TRANSACTION
-- The SET TRANSACTION statement is used to specify characteristics for the current transaction.
-- This includes setting the isolation level, which determines how transaction integrity is visible to other users and systems.

-- Example:
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
UPDATE employees SET hire_date = '2022-01-01' WHERE employee_id = 1;
COMMIT;

-- Transaction Isolation Levels:
-- 1. READ UNCOMMITTED: Allows dirty reads; one transaction may see uncommitted changes made by other transactions.
-- 2. READ COMMITTED: Prevents dirty reads; a transaction cannot read data that is being modified by another transaction until it is committed.
-- 3. REPEATABLE READ: Prevents non-repeatable reads; ensures that if a transaction reads a row, subsequent reads will see the same data.
-- 4. SERIALIZABLE: Ensures full isolation; transactions are completely isolated from each other, as if they were executed serially.

/*********************************************/
/*        Handling Non-Repeatable Reads and Phantom Reads  */
/*********************************************/

-- Non-repeatable Reads
-- Occur when a transaction reads the same row twice and gets different data each time due to another transaction's updates.
-- Example of avoiding non-repeatable reads:
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT * FROM employees WHERE employee_id = 1;
-- Another transaction updates the row here
SELECT * FROM employees WHERE employee_id = 1;
COMMIT;

-- Phantom Reads
-- Occur when a transaction re-executes a query returning a set of rows that satisfies a condition and finds 
-- that the set of rows satisfying the condition has changed due to another recently committed transaction.
-- Example of avoiding phantom reads:
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
SELECT * FROM employees WHERE hire_date = '2022-01-01';
-- Another transaction inserts a new row with hire_date = '2022-01-01' here
SELECT * FROM employees WHERE hire_date = '2022-01-01';
COMMIT;

/*********************************************/
/*        Example: ROLLBACK to Original State */
/*********************************************/

-- Scenario: We want to update multiple records in the employees table. If any update fails, we will rollback to the original state before the transaction started.

START TRANSACTION;

-- Perform first update
UPDATE employees SET hire_date = '2022-01-01' WHERE employee_id = 1;

-- Set a savepoint after the first update
SAVEPOINT first_update;

-- Perform second update
UPDATE employees SET hire_date = '2022-01-02' WHERE employee_id = 2;

-- Simulate a failure (e.g., by checking a condition)
-- Let's assume we have a condition that should not be true
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    -- Rollback to the savepoint if there is an error
    ROLLBACK TO first_update;
    -- Rollback the entire transaction
    ROLLBACK;
END;

-- Check condition (Simulating a failure)
IF (1 = 0) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Simulated failure';
END IF;

-- Perform third update
UPDATE employees SET hire_date = '2022-01-03' WHERE employee_id = 3;

-- Commit the transaction if everything is successful
COMMIT;

-- If any of the updates fail, the ROLLBACK statement will undo all changes, and the database will return to its original state before the transaction started.

