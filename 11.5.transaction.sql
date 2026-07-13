INSERT INTO `product` (`id`, `name`, `price`, `stock`) 
VALUES (6, 'Laptop Gaming', 20000000.00, 10);
INSERT INTO `orders` (`product_id`, `quantity`, `total_price`, `order_date`)
SELECT 6, 0, (`price` * 0), '2026-07-13 11:12:45' FROM `product` WHERE `id` = 6;

DELIMITER //

CREATE PROCEDURE place_order(
	IN p_product_id INT,
    IN p_quantity INT
    )
BEGIN
	DECLARE v_price DECIMAL (15,2);
    DECLARE v_stock INT;
    DECLARE v_total_price DECIMAL (15,2);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SELECT 'Loi he thong, don hang bi huy' AS status;
    END;
    
    START TRANSACTION;
    SELECT price, stock INTO v_price, v_stock
    FROM product
    WHERE id = p_product_id FOR UPDATE;
    
    IF v_price IS NULL THEN 
		ROLLBACK;
		SELECT 'Sp khong ton tai' AS status;
	ELSEIF v_stock < p_quantity THEN
		ROLLBACK;
        SELECT 'So luong hang khong du' AS status;
    ELSE
		UPDATE product
        SET stock = stock - p_quantity
		WHERE id = p_product_id;
	
		SET v_total_price = v_price * p_quantity;
        
        INSERT INTO orders (product_id, quantity, total_price)
        VALUE (p_product_id, p_quantity, v_total_price);
        
        COMMIT;
        SELECT 'Dat hang thanh cong' AS status;
	END IF;
END //

DELIMITER ;

CALL  place_order (6,2);
CALL  place_order (6,20);