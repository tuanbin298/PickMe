-- Payment System Tables Migration
-- Create tables for SePay and Cash payment integration
-- Run this script after the main application tables are created by Hibernate

-- Create payments table
CREATE TABLE IF NOT EXISTS payments (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL CHECK (payment_method IN ('CASH', 'SEPAY')),
    payment_status VARCHAR(50) NOT NULL DEFAULT 'PENDING' 
        CHECK (payment_status IN ('PENDING', 'PROCESSING', 'PAID', 'FAILED', 'REFUNDED', 'EXPIRED')),
    transaction_id VARCHAR(255) UNIQUE,
    sepay_transaction_id BIGINT,
    gateway_response TEXT,
    failure_reason VARCHAR(500),
    qr_code_url TEXT,
    paid_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    
    -- Foreign key constraint
    CONSTRAINT fk_payments_order_id 
        FOREIGN KEY (order_id) 
        REFERENCES orders(id) 
        ON DELETE CASCADE,
        
    -- Unique constraint - one payment per order
    CONSTRAINT unique_payment_per_order UNIQUE (order_id)
);

-- Create sepay_transactions table
CREATE TABLE IF NOT EXISTS sepay_transactions (
    id BIGSERIAL PRIMARY KEY,
    sepay_transaction_id BIGINT NOT NULL UNIQUE,
    gateway VARCHAR(100) NOT NULL,
    transaction_date TIMESTAMP NOT NULL,
    account_number VARCHAR(100),
    sub_account VARCHAR(250),
    transfer_type VARCHAR(10) NOT NULL CHECK (transfer_type IN ('in', 'out')),
    transfer_amount DECIMAL(15,2) NOT NULL,
    accumulated DECIMAL(15,2),
    code VARCHAR(250),
    transaction_content TEXT,
    reference_code VARCHAR(255),
    description TEXT,
    processed BOOLEAN NOT NULL DEFAULT FALSE,
    order_id BIGINT, -- Extracted from transaction_content
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Create indexes for better performance

-- Payments table indexes
CREATE INDEX IF NOT EXISTS idx_payments_order_id ON payments(order_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(payment_status);
CREATE INDEX IF NOT EXISTS idx_payments_method ON payments(payment_method);
CREATE INDEX IF NOT EXISTS idx_payments_transaction_id ON payments(transaction_id);
CREATE INDEX IF NOT EXISTS idx_payments_sepay_transaction_id ON payments(sepay_transaction_id);
CREATE INDEX IF NOT EXISTS idx_payments_created_at ON payments(created_at DESC);

-- SePay transactions table indexes
CREATE INDEX IF NOT EXISTS idx_sepay_transactions_sepay_id ON sepay_transactions(sepay_transaction_id);
CREATE INDEX IF NOT EXISTS idx_sepay_transactions_date ON sepay_transactions(transaction_date DESC);
CREATE INDEX IF NOT EXISTS idx_sepay_transactions_account ON sepay_transactions(account_number);
CREATE INDEX IF NOT EXISTS idx_sepay_transactions_content ON sepay_transactions(transaction_content);
CREATE INDEX IF NOT EXISTS idx_sepay_transactions_reference ON sepay_transactions(reference_code);
CREATE INDEX IF NOT EXISTS idx_sepay_transactions_processed ON sepay_transactions(processed);
CREATE INDEX IF NOT EXISTS idx_sepay_transactions_order_id ON sepay_transactions(order_id);

-- Add comments for documentation
COMMENT ON TABLE payments IS 'Stores payment information for orders with SePay and Cash methods';
COMMENT ON COLUMN payments.payment_method IS 'Payment method: CASH or SEPAY';
COMMENT ON COLUMN payments.payment_status IS 'Payment status: PENDING, PROCESSING, PAID, FAILED, REFUNDED, EXPIRED';
COMMENT ON COLUMN payments.transaction_id IS 'Internal transaction ID or SePay transaction reference';
COMMENT ON COLUMN payments.sepay_transaction_id IS 'SePay transaction ID from webhook';
COMMENT ON COLUMN payments.qr_code_url IS 'QR code URL for SePay payments';

COMMENT ON TABLE sepay_transactions IS 'Stores raw transaction data from SePay webhooks';
COMMENT ON COLUMN sepay_transactions.sepay_transaction_id IS 'Transaction ID from SePay webhook';
COMMENT ON COLUMN sepay_transactions.transfer_type IS 'Transaction type: in (money in) or out (money out)';
COMMENT ON COLUMN sepay_transactions.processed IS 'Whether this transaction has been processed for payment matching';
COMMENT ON COLUMN sepay_transactions.order_id IS 'Order ID extracted from transaction_content using regex';

-- Sample data (optional - remove in production)
-- INSERT INTO payments (order_id, amount, payment_method, payment_status, transaction_id) VALUES
-- (1, 150000.00, 'SEPAY', 'PENDING', 'SEPAY-1-1698552000000'),
-- (2, 200000.00, 'CASH', 'PAID', 'CASH-2-1698552100000');

-- Verify table creation
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name IN ('payments', 'sepay_transactions')
ORDER BY table_name, ordinal_position;