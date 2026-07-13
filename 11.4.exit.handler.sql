DELIMITER //

CREATE PROCEDURE transfer_money(
	IN p_sender_id INT,
    IN p_receiver_id INT,
    IN p_amount DECIMAL (10,2)
    )
BEGIN
	DECLARE sender_balance DECIMAL (10,2);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    
		BEGIN
        ROLLBACK;
        SELECT 'Giao dich that bai, loi he thong' AS status;
        END;
        
	START TRANSACTION;
    SELECT balance INTO sender_balance
    FROM accounts
    WHERE id = p_sender_id FOR UPDATE;
    
    IF sender_balance IS NULL THEN
		ROLLBACK;
		SELECT 'Giao dich that bai, tai khoan khong ton tai' AS status;
	ELSEIF sender_balance < p_amount THEN
		ROLLBACK;
        SELECT 'Tai khoan khong tien giao dich' AS status;
	ELSE 
		UPDATE accounts
        SET balance = balance - p_amount
        WHERE id = p_sender_id;
        
        UPDATE accounts
        SET balance = balance + p_amount
        WHERE id = p_receiver_id;
		
        COMMIT;
        SELECT 'Giao dich thanh cong' AS status;
	END IF;
END //

DELIMITER ;

DROP PROCEDURE transfer_money;

CALL transfer_money (4,5,300000);