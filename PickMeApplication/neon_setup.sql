-- Migration script for Neon Database
-- Chạy script này trên Neon database để setup ban đầu

-- Enable PostGIS extension (nếu cần)
CREATE EXTENSION IF NOT EXISTS postgis;

-- Các table sẽ được tạo tự động bởi Hibernate với ddl-auto=update
-- Nhưng bạn có thể chạy các script setup khác nếu cần:

-- Script tạo bảng user addresses (nếu chưa có)
-- CREATE TABLE IF NOT EXISTS user_addresses (
--     id BIGSERIAL PRIMARY KEY,
--     user_id BIGINT NOT NULL,
--     address_line_1 VARCHAR(255) NOT NULL,
--     address_line_2 VARCHAR(255),
--     city VARCHAR(100) NOT NULL,
--     state VARCHAR(100),
--     postal_code VARCHAR(20),
--     country VARCHAR(100) NOT NULL DEFAULT 'Vietnam',
--     is_default BOOLEAN DEFAULT FALSE,
--     location GEOMETRY(POINT, 4326),
--     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- );

-- Script tạo bảng payments (nếu chưa có)
-- CREATE TABLE IF NOT EXISTS payments (
--     id BIGSERIAL PRIMARY KEY,
--     order_id BIGINT NOT NULL,
--     amount DECIMAL(10,2) NOT NULL,
--     status VARCHAR(50) NOT NULL,
--     payment_method VARCHAR(50) NOT NULL,
--     transaction_id VARCHAR(255),
--     sepay_reference VARCHAR(255),
--     qr_code_url TEXT,
--     expires_at TIMESTAMP,
--     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- );

-- Thêm indexes cho performance
-- CREATE INDEX IF NOT EXISTS idx_user_addresses_user_id ON user_addresses(user_id);
-- CREATE INDEX IF NOT EXISTS idx_user_addresses_location ON user_addresses USING GIST(location);
-- CREATE INDEX IF NOT EXISTS idx_payments_order_id ON payments(order_id);
-- CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(status);
-- CREATE INDEX IF NOT EXISTS idx_payments_transaction_id ON payments(transaction_id);