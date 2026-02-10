--   DATABASE CREATION

CREATE DATABASE IF NOT EXISTS sales_revenue;
USE sales_revenue;

  -- TABLE CREATION

/* Customers Table */
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    created_at DATE
);

/* Products Table */
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

/* Orders Table */
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

/* Payments Table */
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    amount DECIMAL(10,2),
    payment_date DATE,
    payment_method VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

  -- DATA INSERTION

/* Customers */
INSERT INTO customers (name, email, city, created_at) VALUES
('Ravi', 'ravi@gmail.com', 'Hyderabad', '2024-01-10'),
('Anita', 'anita@gmail.com', 'Bangalore', '2024-01-12'),
('Kiran', 'kiran@gmail.com', 'Chennai', '2024-02-05'),
('Priya', 'priya@gmail.com', 'Mumbai', '2024-02-10'),
('Arjun', 'arjun@gmail.com', 'Delhi', '2024-03-01');

/* Products */
INSERT INTO products (product_name, category, price) VALUES
('Laptop', 'Electronics', 60000),
('Mobile', 'Electronics', 30000),
('Shoes', 'Fashion', 2500),
('Headphones', 'Accessories', 1500),
('Backpack', 'Accessories', 2000);

/* Orders */
INSERT INTO orders (customer_id, order_date) VALUES
(1, '2024-03-01'),
(2, '2024-03-02'),
(1, '2024-03-05'),
(3, '2024-03-06'),
(4, '2024-03-10');

/* Payments */
INSERT INTO payments (order_id, amount, payment_date, payment_method) VALUES
(1, 60000, '2024-03-01', 'UPI'),
(2, 30000, '2024-03-02', 'CARD'),
(3, 2500, '2024-03-05', 'UPI'),
(4, 1500, '2024-03-06', 'COD'),
(5, 2000, '2024-03-10', 'CARD');

-- REPORT QUERIES

/* Daily Revenue */
SELECT 
    payment_date,
    SUM(amount) AS daily_revenue
FROM payments
GROUP BY payment_date
ORDER BY payment_date;

/* Monthly Revenue */
SELECT 
    YEAR(payment_date) AS year,
    MONTH(payment_date) AS month,
    SUM(amount) AS monthly_revenue
FROM payments
GROUP BY year, month;

/* Total Revenue */
SELECT SUM(amount) AS total_revenue
FROM payments;

 --  ANALYTICS QUERIES

/* Orders per Customer */
SELECT 
    c.name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

/* Revenue per Customer */
SELECT 
    c.name,
    SUM(p.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.customer_id, c.name;

  -- JOIN QUERIES

/* Customer Orders */
SELECT 
    c.name,
    o.order_id,
    o.order_date
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

/* Order Payment Details */
SELECT 
    o.order_id,
    o.order_date,
    p.amount,
    p.payment_method
FROM orders o
JOIN payments p ON o.order_id = p.order_id;

 --  DATE FILTER QUERIES

/* Today's Sales */
SELECT SUM(amount) AS today_sales
FROM payments
WHERE payment_date = CURDATE();

/* Last 7 Days Sales */
SELECT SUM(amount) AS last_7_days_sales
FROM payments
WHERE payment_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);

/* Current Month Sales */
SELECT SUM(amount) AS current_month_sales
FROM payments
WHERE MONTH(payment_date) = MONTH(CURDATE())
  AND YEAR(payment_date) = YEAR(CURDATE());
