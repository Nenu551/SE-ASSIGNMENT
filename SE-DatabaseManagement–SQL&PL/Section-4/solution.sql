-- ============================================================================
-- Section 4: Stored Procedure Testing & Debugging
-- File: solution.sql
-- ============================================================================

USE food_delivery_db;

-- Drop procedure if it exists
DROP PROCEDURE IF EXISTS get_monthly_restaurant_summary;

-- ============================================================================
-- AI'S ORIGINAL STORED PROCEDURE (FOR REFERENCE & TESTING)
-- ============================================================================

/*
DELIMITER $$

CREATE PROCEDURE get_monthly_restaurant_summary_ai(
    IN p_restaurant_id INT,
    IN p_month INT
)
BEGIN
    DECLARE order_count INT DEFAULT 0;

    SELECT COUNT(*) INTO order_count
    FROM orders
    WHERE restaurant_id = p_restaurant_id AND MONTH(order_date) = p_month;

    IF order_count > 0 THEN
        SELECT 
            restaurant_id,
            COUNT(order_id) AS total_orders,
            SUM(total_amount) AS total_revenue,
            AVG(total_amount) AS average_order_value
        FROM orders
        WHERE restaurant_id = p_restaurant_id AND MONTH(order_date) = p_month
        GROUP BY restaurant_id;
    ELSE
        SELECT 'No orders found for this restaurant in the specified month' AS Message;
    END IF;
END$$

DELIMITER ;
*/

-- ============================================================================
-- CORRECTED & IMPROVED STORED PROCEDURE
-- ============================================================================

DELIMITER $$

CREATE PROCEDURE get_monthly_restaurant_summary(
    IN p_restaurant_id INT,
    IN p_month INT,
    IN p_year INT
)
BEGIN
    DECLARE v_restaurant_exists INT DEFAULT 0;
    DECLARE v_order_count INT DEFAULT 0;
    DECLARE v_restaurant_name VARCHAR(100) DEFAULT '';

    -- 1. Input Validation: Check month range (1 to 12)
    IF p_month < 1 OR p_month > 12 THEN
        SELECT 'Error: Month must be an integer between 1 and 12.' AS Message;
    ELSE
        -- 2. Validation: Check if restaurant exists in restaurants table
        SELECT COUNT(*), COALESCE(MAX(name), '') INTO v_restaurant_exists, v_restaurant_name
        FROM restaurants
        WHERE restaurant_id = p_restaurant_id;

        IF v_restaurant_exists = 0 THEN
            SELECT CONCAT('Error: Restaurant ID ', p_restaurant_id, ' does not exist.') AS Message;
        ELSE
            -- 3. Check order count for specified restaurant, month, AND year
            SELECT COUNT(*) INTO v_order_count
            FROM orders
            WHERE restaurant_id = p_restaurant_id 
              AND MONTH(order_date) = p_month
              AND YEAR(order_date) = p_year;

            IF v_order_count > 0 THEN
                SELECT 
                    r.restaurant_id,
                    r.name AS restaurant_name,
                    p_month AS month_num,
                    p_year AS year_num,
                    COUNT(o.order_id) AS total_orders,
                    COALESCE(SUM(o.total_amount), 0.00) AS total_revenue,
                    ROUND(AVG(o.total_amount), 2) AS average_order_value
                FROM restaurants r
                JOIN orders o ON r.restaurant_id = o.restaurant_id
                WHERE r.restaurant_id = p_restaurant_id 
                  AND MONTH(o.order_date) = p_month
                  AND YEAR(o.order_date) = p_year
                GROUP BY r.restaurant_id, r.name;
            ELSE
                SELECT CONCAT('No orders found for ', v_restaurant_name, ' (ID: ', p_restaurant_id, ') in ', p_month, '/', p_year, '.') AS Message;
            END IF;
        END IF;
    END IF;
END$$

DELIMITER ;

-- ============================================================================
-- TEST CASES FOR MYSQL WORKBENCH RUN
-- ============================================================================

-- Test Case 1: Restaurant 1 (Spice Villa), Month 7 (July), Year 2026 -> Has orders
CALL get_monthly_restaurant_summary(1, 7, 2026);

-- Test Case 2: Restaurant 2 (Pizza Hub), Month 7 (July), Year 2026 -> Has orders
CALL get_monthly_restaurant_summary(2, 7, 2026);

-- Test Case 3: Restaurant 1 (Spice Villa), Month 5 (May), Year 2026 -> No orders in month
CALL get_monthly_restaurant_summary(1, 5, 2026);

-- Test Case 4: Non-existent Restaurant (ID 999), Month 7, Year 2026 -> Invalid Restaurant ID
CALL get_monthly_restaurant_summary(999, 7, 2026);

-- Test Case 5: Invalid Month Number (15) -> Invalid Month Error
CALL get_monthly_restaurant_summary(1, 15, 2026);
