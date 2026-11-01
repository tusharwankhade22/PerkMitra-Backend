-- =====================================================
-- PerkMitra
-- Migration V1: Create Application Schema
-- =====================================================

-- Create the application schema if it does not exist.
CREATE SCHEMA IF NOT EXISTS app;

-- Set the schema comment.
COMMENT ON SCHEMA app IS
'Application schema for the PerkMitra loyalty platform';