INSERT INTO transaction2 (`account_id`, `amount`, `log_message`, `transaction_date`) 
VALUES 
(1, 1000000.00, 'Nạp tiền vào tài khoản', '2026-07-01 09:15:00'),
(2, 50000.00, 'Nạp tiền vào tài khoản', '2026-07-02 14:30:22'),
(3, 500000.00, 'Rút tiền từ tài khoản', '2026-07-03 10:05:11'),
(4, 200000.00, 'Nạp tiền vào tài khoản', '2026-07-05 16:45:30'),
(5, 150000.00, 'Rút tiền từ tài khoản', '2026-07-06 08:20:00'),
(1, 200000.00, 'Rút tiền từ tài khoản', '2026-07-07 11:12:45'),
(6, 5000000.00, 'Nạp tiền vào tài khoản', '2026-07-08 19:35:18'),
(7, 1000000.00, 'Rút tiền từ tài khoản', '2026-07-10 13:00:00'),
(8, 350000.00, 'Nạp tiền vào tài khoản', '2026-07-11 15:22:05'),
(3, 1500000.00, 'Nạp tiền vào tài khoản', '2026-07-12 17:50:00');

DELIMITER //

CREATE PROCEDURE deposit_with_logging(
	IN p_account_id INT,
    IN p_amount DECIMAL(10,2)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SELECT 'Loi he thong, giao dich bi huy';
	END;
    
	START TRANSACTION;
    UPDATE accounts
    SET balance = balance + p_amount
    WHERE id = p_account_id;
    
    INSERT INTO transaction2 (account_id, amount, log_message)
    VALUES (
		p_account_id,
        p_amount,
        CONCAT('Nap tien vao tai khoan +', FORMAT (p_amount, 0), 'VND')
        );
	COMMIT;
    SELECT 'Thanh cong, Nap tien va ghi log hoan tat' AS `Status`;
END //

DELIMITER ;

CALL deposit_with_logging (3,1000000);