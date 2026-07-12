CREATE TABLE `accounts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `balance` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `chk_balance_positive` CHECK ((`balance` >= 0))
);

CREATE TABLE `transactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `from_account_id` int DEFAULT NULL,
  `to_account_id` int DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `transacion_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_account1_idx` (`from_account_id`),
  KEY `fk_account2_idx` (`to_account_id`),
  CONSTRAINT `fk_account1` FOREIGN KEY (`from_account_id`) REFERENCES `accounts` (`id`),
  CONSTRAINT `fk_account2` FOREIGN KEY (`to_account_id`) REFERENCES `accounts` (`id`)
);

ALTER TABLE accounts
ADD CONSTRAINT chk_balance_positive CHECK (balance >= 0);

DELIMITER //

CREATE PROCEDURE withdraw_money(
	IN p_account_id INT,
    IN p_amount DECIMAL (10,2)
)
BEGIN
	DECLARE current_balance DECIMAL (10,2);
    START TRANSACTION;
    
    UPDATE accounts
    SET balance = balance - p_amount
    WHERE id = p_account_id;
    
    SELECT balance INTO current_balance
    FROM accounts
    WHERE id = p_account_id;
    
    IF current_balance < 0 THEN
		ROLLBACK;
        SELECT 'Khong du so du';
	ELSE 
		COMMIT;
        SELECT 'Rut tien thanh cong';
	END IF;
END //

DELIMITER ;

CALL withdraw_money(2,500000);
CALL withdraw_money(2,100000);

DROP PROCEDURE withdraw_money;