START TRANSACTION;
UPDATE accounts
SET balance = balance + 1000000.00
WHERE id = 1;
COMMIT;

SELECT * FROM accounts
WHERE id = 1;