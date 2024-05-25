/*********************************************/
/*                                           */
/*          Chapter 17: Concurrency Control  */
/*                                           */
/*********************************************/

/*********************************************/
/*              Introduction                 */
/*********************************************/

-- Concurrency control in SQL ensures that database transactions are performed concurrently without leading to data inconsistency.
-- It involves managing access to data when multiple transactions occur simultaneously.

-- Key Concepts:
-- 1. Locking Mechanisms
-- 2. Transaction Isolation Levels
-- 3. Deadlocks
-- 4. Best Practices

/*********************************************/
/*           Locking Mechanisms              */
/*********************************************/

-- Locks are used to control access to database resources.
-- Types of Locks:
-- 1. Shared Locks (S): Allow multiple transactions to read a resource but not modify it.
-- 2. Exclusive Locks (X): Allow a transaction to both read and modify a resource.
-- 3. Intention Locks: Indicate the intention of acquiring a shared or exclusive lock on a resource.

-- Example: Using Explicit Locks
START TRANSACTION;
-- Acquire a shared lock
SELECT * FROM employees WHERE department_id = 1 LOCK IN SHARE MODE;

-- Acquire an exclusive lock
SELECT * FROM employees WHERE department_id = 1 FOR UPDATE;
COMMIT;

/*********************************************/
/*       Transaction Isolation Levels        */
/*********************************************/

-- Transaction isolation levels define the degree to which the operations in one transaction are isolated from those in other transactions.
-- Isolation Levels:
-- 1. Read Uncommitted: Allows dirty reads, non-repeatable reads, and phantom reads.
-- 2. Read Committed: Prevents dirty reads but allows non-repeatable reads and phantom reads.
-- 3. Repeatable Read: Prevents dirty reads and non-repeatable reads but allows phantom reads.
-- 4. Serializable: Prevents dirty reads, non-repeatable reads, and phantom reads.

-- Example: Setting Isolation Level
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Example: Using Isolation Levels
START TRANSACTION;
-- Perform operations here
COMMIT;

/*********************************************/
/*                Deadlocks                  */
/*********************************************/

-- A deadlock occurs when two or more transactions are waiting for each other to release locks, causing all transactions to be blocked indefinitely.

-- Example: Detecting and Handling Deadlocks
-- MySQL automatically detects deadlocks and rolls back one of the transactions to break the deadlock.
-- You can use the SHOW ENGINE INNODB STATUS command to check for deadlocks.

-- Example: Simulating a Deadlock
-- Transaction 1
START TRANSACTION;
UPDATE employees SET salary = salary + 5000 WHERE department_id = 1;

-- Transaction 2 (run simultaneously in another session)
START TRANSACTION;
UPDATE employees SET salary = salary + 4000 WHERE department_id = 2;

-- Continue Transaction 1
UPDATE employees SET salary = salary + 5000 WHERE department_id = 2;

-- Continue Transaction 2 (this will cause a deadlock)
UPDATE employees SET salary = salary + 4000 WHERE department_id = 1;

/*********************************************/
/*              Best Practices               */
/*********************************************/

-- Best Practices for Concurrency Control:
-- 1. Use the appropriate isolation level for your application requirements.
-- 2. Keep transactions short and concise to reduce lock contention.
-- 3. Use explicit locks when necessary to control access to critical resources.
-- 4. Monitor for deadlocks and design your application to handle them gracefully.
-- 5. Use optimistic locking techniques when possible to reduce lock contention.
-- 6. Regularly analyze and optimize queries to improve concurrency.

/*********************************************/
/*         Additional Concurrency Concepts   */
/*********************************************/

-- Multi-Version Concurrency Control (MVCC):
-- MVCC is a technique that allows multiple transactions to access the database concurrently without interfering with each other.
-- MySQL's InnoDB storage engine uses MVCC to implement isolation levels like Read Committed and Repeatable Read.

-- Example: Understanding MVCC
-- When a transaction begins, it gets a snapshot of the database at that point in time.
-- Changes made by other transactions are not visible until the transaction is committed.

/*********************************************/
/*              Example Setup                */
/*********************************************/

-- Example: Setting Up Concurrency Control
-- Step 1: Set the isolation level
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Step 2: Start a transaction and perform operations
START TRANSACTION;
UPDATE employees SET salary = salary + 5000 WHERE employee_id = 1;

-- Step 3: Commit the transaction
COMMIT;

-- Step 4: Handle deadlocks (example)
-- Retry the transaction if a deadlock is detected
DELIMITER $$
CREATE PROCEDURE handle_deadlock()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback the transaction
        ROLLBACK;
        -- Retry logic or error handling
        SELECT 'Deadlock detected, transaction rolled back' AS error_message;
    END;

    -- Transaction operations
    START TRANSACTION;
    UPDATE employees SET salary = salary + 5000 WHERE employee_id = 1;
    COMMIT;
END $$
DELIMITER ;

-- Calling the procedure
CALL handle_deadlock();
