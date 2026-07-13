DELIMITER //

CREATE PROCEDURE cancel_order(
	IN p_order_id INT
    )
BEGIN
	DECLARE v_product_id INT;
    DECLARE v_quantity INT;
    DECLARE v_status VARCHAR(20);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	
    BEGIN
		ROLLBACK;
        SELECT 'Loi he thong, khong the huy don' AS status;
	END;
    
    START TRANSACTION;
    SELECT product_id, quantity, status INTO v_product_id, v_quantity, v_status
    FROM orders
    WHERE id = p_order_id FOR UPDATE;
    
    IF v_status IS NULL THEN
		ROLLBACK;
        SELECT 'Don hang khong ton tai' AS status;
	ELSEIF v_status = 'Cancelled' THEN
		ROLLBACK;
        SELECT 'Don hang da bi huy truoc day' AS status;
	ELSE 
		UPDATE orders
        SET status = 'Cancelled'
        WHERE id = p_order_id;
        
        UPDATE product
		SET stock = stock + v_quantity
        WHERE id = v_product_id;
        
        COMMIT;
        SELECT 'Huy don hang va hoan kho thanh cong' AS status;
	END IF;
END //

DELIMITER ; 

CALL place_order(6,2);
CALL cancel_order(8);

DROP PROCEDURE cancel_order;
