-- User Addresses Table Migration
-- Create table for storing user addresses with spatial support
-- Run this script after the main application tables are created by Hibernate

-- Create user_addresses table if not exists
CREATE TABLE IF NOT EXISTS user_addresses (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    address_name VARCHAR(100) NOT NULL,
    full_address VARCHAR(500) NOT NULL,
    location GEOMETRY(POINT, 4326), -- PostGIS Point for GPS coordinates
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    
    -- Foreign key constraint
    CONSTRAINT fk_user_addresses_user_id 
        FOREIGN KEY (user_id) 
        REFERENCES users(id) 
        ON DELETE CASCADE,
    
    -- Ensure only one default address per user
    CONSTRAINT unique_default_per_user 
        EXCLUDE (user_id WITH =) 
        WHERE (is_default = true)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_user_addresses_user_id 
    ON user_addresses(user_id);

CREATE INDEX IF NOT EXISTS idx_user_addresses_is_default 
    ON user_addresses(is_default) WHERE is_default = true;

CREATE INDEX IF NOT EXISTS idx_user_addresses_created_at 
    ON user_addresses(created_at DESC);

-- Spatial index for location-based queries
CREATE INDEX IF NOT EXISTS idx_user_addresses_location 
    ON user_addresses USING GIST(location);

-- Comments for documentation
COMMENT ON TABLE user_addresses IS 'Stores user delivery/pickup addresses with GPS coordinates';
COMMENT ON COLUMN user_addresses.address_name IS 'User-friendly name for the address (Home, Office, etc.)';
COMMENT ON COLUMN user_addresses.full_address IS 'Complete address string';
COMMENT ON COLUMN user_addresses.location IS 'GPS coordinates in WGS84 (SRID 4326)';
COMMENT ON COLUMN user_addresses.is_default IS 'Whether this is the default address for the user';

-- Sample data (optional - remove in production)
-- INSERT INTO user_addresses (user_id, address_name, full_address, location, is_default) VALUES
-- (1, 'Nhà', '123 Nguyễn Văn Cừ, Quận 5, TP.HCM', ST_GeomFromText('POINT(106.68 10.76)', 4326), true),
-- (1, 'Công ty', '456 Lê Lợi, Quận 1, TP.HCM', ST_GeomFromText('POINT(106.70 10.77)', 4326), false);

-- Verify table creation
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'user_addresses'
ORDER BY ordinal_position;