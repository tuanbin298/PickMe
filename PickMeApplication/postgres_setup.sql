-- PostgreSQL Setup for PickMe Application
-- Run this script to setup your local PostgreSQL database

-- Create database (run as postgres superuser)
CREATE DATABASE pickmeapplication
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TEMPLATE = template0;

-- Connect to the database
\c pickmeapplication;

-- Enable PostGIS extension
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;

-- Verify PostGIS installation
SELECT PostGIS_Version();

-- Create custom types for enum values (optional, Hibernate will create them)
-- CREATE TYPE approval_status AS ENUM ('PENDING', 'APPROVED', 'REJECTED');
-- CREATE TYPE role AS ENUM ('USER', 'RESTAURANT_OWNER', 'ADMIN');

-- Grant necessary privileges
GRANT ALL PRIVILEGES ON DATABASE pickmeapplication TO postgres;
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO postgres;

-- Create spatial indexes (will be created by Hibernate but can be optimized)
-- These will be created after Hibernate generates the tables

COMMENT ON DATABASE pickmeapplication IS 'PickMe Food Delivery Application Database';