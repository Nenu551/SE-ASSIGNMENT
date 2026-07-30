-- ============================================================================
-- Mini Project: Food Delivery Platform — Backend Database
-- File: project.sql
-- Description: Complete backend database script combining DDL, DML, JOINs, 
--              Views, Stored Procedures, and Triggers for a Food Delivery App.
-- ============================================================================

-- Step 1: Database Creation and Selection
CREATE DATABASE IF NOT EXISTS food_delivery_db;
USE food_delivery_db;

-- ============================================================================
-- Step 2: Cleanup Existing Database Objects (Reverse Dependency Order)
-- ============================================================================
DROP TRIGGER IF EXISTS after_order_insert;
DROP PROCEDURE IF EXISTS add_order;
DROP VIEW IF EXISTS restaurant_sales_summary;
DROP TABLE IF EXISTS order_audit;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS menu_items;
DROP TABLE IF EXISTS restaurants;

-- ============================================================================
-- Step 3: DDL - Table Creation
-- ============================================================================

-- Table 1: restaurants
-- Stores information about partner restaurants
CREATE TABLE restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    cuisine_type VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table 2: menu_items
-- Stores food items offered by each restaurant
CREATE TABLE menu_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50) NOT NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id) ON DELETE CASCADE
);

-- Table 3: orders
-- Stores customer orders
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    restaurant_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    total_amount DECIMAL(10, 2) NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id) ON DELETE CASCADE
);

-- Table 4: order_audit
-- Audit table to log new order creations via Trigger
CREATE TABLE order_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    action VARCHAR(20) NOT NULL DEFAULT 'INSERT',
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- Step 4: DML - Data Population
-- ============================================================================

-- Insert Restaurants (4 Restaurants)
INSERT INTO restaurants (name, city, cuisine_type) VALUES
('Spice Villa', 'Ahmedabad', 'North Indian'),
('Pizza Hub', 'Mumbai', 'Italian'),
('Dragon Wok', 'Delhi', 'Chinese'),
('Royal Biryani', 'Hyderabad', 'Mughlai');

-- Insert Menu Items across 4 Categories: 'Main Course', 'Appetizer', 'Dessert', 'Beverage'
INSERT INTO menu_items (restaurant_id, item_name, price, category) VALUES
-- Spice Villa (Restaurant 1)
(1, 'Paneer Butter Masala', 280.00, 'Main Course'),
(1, 'Dal Makhani', 220.00, 'Main Course'),
(1, 'Garlic Naan', 50.00, 'Bread'),
(1, 'Gulab Jamun', 90.00, 'Dessert'),
(1, 'Mango Lassi', 80.00, 'Beverage'),

-- Pizza Hub (Restaurant 2)
(2, 'Margherita Pizza', 350.00, 'Main Course'),
(2, 'Garlic Breadsticks', 140.00, 'Appetizer'),
(2, 'Pasta Alfredo', 310.00, 'Main Course'),
(2, 'Choco Lava Cake', 120.00, 'Dessert'),
(2, 'Iced Tea', 70.00, 'Beverage'),

-- Dragon Wok (Restaurant 3)
(3, 'Hakka Noodles', 240.00, 'Main Course'),
(3, 'Veg Manchurian', 210.00, 'Appetizer'),
(3, 'Spring Rolls', 180.00, 'Appetizer'),
(3, 'Honey Noodles with Ice Cream', 150.00, 'Dessert'),

-- Royal Biryani (Restaurant 4)
(4, 'Hyderabadi Chicken Biryani', 380.00, 'Main Course'),
(4, 'Mutton Biryani', 450.00, 'Main Course'),
(4, 'Chicken Tikka', 290.00, 'Appetizer'),
(4, 'Double Ka Meetha', 110.00, 'Dessert');

-- Insert 15 Initial Order Records distributed across restaurants
INSERT INTO orders (customer_name, restaurant_id, item_id, quantity, total_amount, order_date) VALUES
('Aarav Sharma', 1, 1, 2, 560.00, '2026-07-20 12:30:00'),
('Priya Patel', 1, 3, 4, 200.00, '2026-07-20 13:15:00'),
('Rohan Verma', 1, 5, 2, 160.00, '2026-07-21 14:00:00'),
('Sneha Gupta', 2, 6, 1, 350.00, '2026-07-21 18:45:00'),
('Vikram Singh', 2, 7, 2, 280.00, '2026-07-22 19:10:00'),
('Ananya Roy', 2, 9, 3, 360.00, '2026-07-22 20:00:00'),
('Karan Mehta', 2, 10, 2, 140.00, '2026-07-23 20:30:00'),
('Neha Joshi', 3, 11, 2, 480.00, '2026-07-23 21:00:00'),
('Rahul Nair', 3, 12, 1, 210.00, '2026-07-24 13:00:00'),
('Pooja Das', 3, 13, 2, 360.00, '2026-07-24 13:30:00'),
('Amit Kumar', 4, 15, 2, 760.00, '2026-07-25 19:30:00'),
('Diya Kapoor', 4, 16, 1, 450.00, '2026-07-25 20:15:00'),
('Siddharth Rao', 4, 17, 2, 580.00, '2026-07-26 21:00:00'),
('Meera Reddy', 4, 18, 2, 220.00, '2026-07-26 21:30:00'),
('Gaurav Bhatia', 1, 2, 2, 440.00, '2026-07-27 12:45:00');

-- ============================================================================
-- Step 5: VIEW - restaurant_sales_summary
-- Summarizes restaurant name, total number of orders, and total revenue
-- ============================================================================

CREATE VIEW restaurant_sales_summary AS
SELECT 
    r.name AS restaurant_name,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0.00) AS total_revenue
FROM restaurants r
LEFT JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.name;

-- ============================================================================
-- Step 6: STORED PROCEDURE - add_order
-- Accepts customer_name, restaurant_id, item_id, quantity.
-- Calculates total_amount from menu_item price.
-- Validates restaurant existence (ROLLBACK if invalid), then inserts order.
-- ============================================================================

DELIMITER $$

CREATE PROCEDURE add_order(
    IN p_customer_name VARCHAR(100),
    IN p_restaurant_id INT,
    IN p_item_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_rest_exists INT DEFAULT 0;
    DECLARE v_item_price DECIMAL(10, 2) DEFAULT 0.00;
    DECLARE v_calculated_total DECIMAL(10, 2) DEFAULT 0.00;

    -- Start Transaction
    START TRANSACTION;

    -- Check if restaurant exists
    SELECT COUNT(*) INTO v_rest_exists
    FROM restaurants
    WHERE restaurant_id = p_restaurant_id;

    IF v_rest_exists = 0 THEN
        -- Rollback and exit if restaurant does not exist
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Restaurant ID does not exist. Transaction rolled back.';
    ELSE
        -- Fetch menu item price
        SELECT price INTO v_item_price
        FROM menu_items
        WHERE item_id = p_item_id AND restaurant_id = p_restaurant_id;

        IF v_item_price IS NULL THEN
            -- Rollback if menu item does not exist for this restaurant
            ROLLBACK;
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Menu item ID does not exist for this restaurant. Transaction rolled back.';
        ELSE
            -- Calculate total amount
            SET v_calculated_total = v_item_price * p_quantity;

            -- Insert order record
            INSERT INTO orders (customer_name, restaurant_id, item_id, quantity, total_amount, order_date)
            VALUES (p_customer_name, p_restaurant_id, p_item_id, p_quantity, v_calculated_total, NOW());

            -- Commit Transaction
            COMMIT;
            SELECT 'Order added successfully' AS result;
        END IF;
    END IF;
END$$

DELIMITER ;

-- ============================================================================
-- Step 7: TRIGGER - after_order_insert
-- Logs a record into order_audit after every new order creation
-- ============================================================================

DELIMITER $$

CREATE TRIGGER after_order_insert
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    INSERT INTO order_audit (order_id, restaurant_id, action, log_time)
    VALUES (NEW.order_id, NEW.restaurant_id, 'INSERT', NOW());
END$$

DELIMITER ;

-- ============================================================================
-- Step 8: Demonstration and Verification Queries
-- ============================================================================

-- 1. Display All Restaurants
SELECT * FROM restaurants;

-- 2. Display Sample Menu Items
SELECT * FROM menu_items;

-- 3. Display Initial 15 Orders
SELECT * FROM orders;

-- 4. Display Sales Summary View
SELECT * FROM restaurant_sales_summary;

-- 5. Test Stored Procedure `add_order` (Valid Order insertion)
-- Customer 'Ravi Patel', Restaurant 1 (Spice Villa), Item 1 (Paneer Butter Masala @ 280), Quantity 2
CALL add_order('Ravi Patel', 1, 1, 2);

-- 6. Verify Trigger Execution in `order_audit`
SELECT * FROM order_audit;

-- 7. Display Updated Sales Summary View
SELECT * FROM restaurant_sales_summary;

-- 8. Test Rollback in Stored Procedure (Invalid Restaurant ID 999)
-- CALL add_order('Test User', 999, 1, 1); -- Will trigger ROLLBACK and SQL Exception
