-- =============================================
-- Inventory Manager Database Schema
-- =============================================

CREATE DATABASE IF NOT EXISTS InventoryManager;
USE InventoryManager;

-- =============================================
-- Users Table
-- =============================================
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- Categories Table
-- =============================================
CREATE TABLE IF NOT EXISTS Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- =============================================
-- Suppliers Table
-- =============================================
CREATE TABLE IF NOT EXISTS Suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    company_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- =============================================
-- Products Table
-- =============================================
CREATE TABLE IF NOT EXISTS Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    sku VARCHAR(50) NOT NULL UNIQUE,
    product_name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    supplier_id INT,
    unit_price DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    reorder_level INT DEFAULT 10,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE RESTRICT,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE SET NULL
);

-- =============================================
-- Inventory Transactions Table
-- =============================================
CREATE TABLE IF NOT EXISTS Inventory_Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    transaction_type ENUM('IN', 'OUT') NOT NULL,
    quantity INT NOT NULL,
    transaction_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
);

-- =============================================
-- Create Indexes for Better Performance
-- =============================================
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_categories_user ON Categories(user_id);
CREATE INDEX idx_suppliers_user ON Suppliers(user_id);
CREATE INDEX idx_products_user ON Products(user_id);
CREATE INDEX idx_products_category ON Products(category_id);
CREATE INDEX idx_products_supplier ON Products(supplier_id);
CREATE INDEX idx_transactions_product ON Inventory_Transactions(product_id);
CREATE INDEX idx_transactions_date ON Inventory_Transactions(transaction_date);

-- =============================================
-- Sample Data (Optional - for testing)
-- =============================================

-- Insert test user
INSERT INTO users (username, password) VALUES 
('admin', '$2y$10$lKKFLPW.1e2eKrpM3V3Wte5j5pW4kKtH3zU5z8U5zV5zV5zV5zV5z');
-- Password: admin123

-- Insert sample categories
INSERT INTO Categories (user_id, category_name) VALUES 
(1, 'Electronics'),
(1, 'Office Supplies'),
(1, 'Furniture');

-- Insert sample suppliers
INSERT INTO Suppliers (user_id, company_name, contact_email, contact_phone) VALUES 
(1, 'Tech Supplies Inc.', 'contact@techsupplies.com', '555-0100'),
(1, 'Office Essentials', 'sales@officeessentials.com', '555-0200'),
(1, 'Furniture World', 'info@furnitureworld.com', '555-0300');

-- Insert sample products
INSERT INTO Products (user_id, sku, product_name, category_id, supplier_id, unit_price, reorder_level, is_active) VALUES 
(1, 'LAPTOP-001', 'Dell Laptop', 1, 1, 999.99, 5, TRUE),
(1, 'MOUSE-001', 'Wireless Mouse', 1, 1, 29.99, 20, TRUE),
(1, 'PEN-001', 'Ballpoint Pen Pack', 2, 2, 9.99, 50, TRUE),
(1, 'CHAIR-001', 'Office Chair', 3, 3, 199.99, 3, TRUE);

-- Insert sample transactions
INSERT INTO Inventory_Transactions (product_id, transaction_type, quantity, transaction_date, notes) VALUES 
(1, 'IN', 10, NOW(), 'Initial stock'),
(2, 'IN', 50, NOW(), 'Initial stock'),
(3, 'IN', 100, NOW(), 'Initial stock'),
(4, 'IN', 5, NOW(), 'Initial stock');
