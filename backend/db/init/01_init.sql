-- Database initialization script
-- This script runs when the PostgreSQL container starts

-- Create the database if it doesn't exist
SELECT 'CREATE DATABASE listing_aggregator_development'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'listing_aggregator_development')\gexec

-- Create the test database if it doesn't exist
SELECT 'CREATE DATABASE listing_aggregator_test'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'listing_aggregator_test')\gexec
