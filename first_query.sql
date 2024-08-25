-- SQL Script: Orders Table Management and Data Insertion

-- Step 1: Drop the existing 'orders' table if it already exists
DROP TABLE IF EXISTS orders;

-- Step 2: Create a new 'orders' table with the following columns:
--   order_id: Unique identifier for each order (INTEGER)
--   customer_id: Identifier for the customer who placed the order (INTEGER)
--   order_date: Date when the order was placed (DATE)
--   order_amount: Monetary value of the order (DECIMAL with 2 decimal places)
CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    order_date DATE,
    order_amount DECIMAL(10, 2)
);

-- Step 3: Insert sample data into the 'orders' table
-- Each row represents a specific order with associated details
INSERT INTO orders (order_id, customer_id, order_date, order_amount) VALUES
(1, 101, '2024-01-10', 1500.00),
(2, 101, '2024-02-15', 1000.00),
(3, 101, '2024-03-20', 900.00),
(4, 102, '2024-01-12', 200.00),
(5, 102, '2024-02-25', 150.00),
(6, 102, '2024-03-10', 320.00),
(7, 103, '2024-01-25', 400.00),
(8, 103, '2024-02-15', 420.00);


-- SQL Query to Retrieve Latest and Second-Latest Order Amounts for Each Customer

-- Step 1: Create a Common Table Expression (CTE) named 'RankedOrders'
-- The CTE assigns a rank to each order within each customer group based on the order date in descending order.
WITH RankedOrders AS (
    SELECT 
        customer_id, 
        order_amount,
        -- ROW_NUMBER() function provides a unique rank to each order within the partitioned customer group
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
    FROM 
        orders
)

-- Step 2: Select the customer_id and calculate the latest and second-latest order amounts
SELECT 
    customer_id,
    -- Use MAX() with CASE to extract the order amount where the rank is 1 (latest order)
    MAX(CASE 
        WHEN rn = 1 THEN order_amount END) AS latest_order_amount,
    -- Use MAX() with CASE to extract the order amount where the rank is 2 (second-latest order)
    MAX(CASE
        WHEN rn = 2 THEN order_amount END) AS second_latest_order_amount
FROM 
    RankedOrders
-- Group by customer_id to aggregate results for each customer
GROUP BY 
    customer_id;

-- End of query
