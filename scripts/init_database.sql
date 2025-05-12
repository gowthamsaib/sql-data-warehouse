-- ========================================
-- File: init_database.sql
-- Author: Gowtham Sai Bhuvanam
-- Created: 05/12/2025
-- Project: Data Warehouse & Analytics Portfolio Project
--
-- Purpose:
-- This script initializes the SQL Server database environment for the Data Warehouse project.
-- It performs the following actions:
--   1. Creates a new database named 'DataWarehouse' (if it doesn't already exist).
--   2. Creates three schemas: 'bronze', 'silver', and 'gold' to follow the Medallion Architecture.
--      - bronze: Raw data ingested from source systems
--      - silver: Cleaned and transformed intermediate data
--      - gold: Final, business-ready data models for analytics
--
-- Use this script to bootstrap the foundational structure of the data warehouse before loading any data.
-- ========================================

-- Switch to the master database to create a new one
USE master;
GO

-- Create the primary Data Warehouse database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'DataWarehouse')
BEGIN
    CREATE DATABASE DataWarehouse;
END
GO

-- Switch to the newly created database
USE DataWarehouse;
GO

-- Create Medallion Architecture schemas: Bronze, Silver, Gold
-- Bronze: Raw ingestion
-- Silver: Cleaned and transformed data
-- Gold: Business-ready analytics models

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze');
END
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver')
BEGIN
    EXEC('CREATE SCHEMA silver');
END
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'gold')
BEGIN
    EXEC('CREATE SCHEMA gold');
END
GO