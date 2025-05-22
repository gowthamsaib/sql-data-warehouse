-- ========================================
-- File: bronze_tables.sql
-- Author: Gowtham Sai Bhuvanam
-- Created On:     5/14/2025
-- Project: SQL-Based ETL Pipeline & Analytics Architecture: CRM + ERP Integration
-- Purpose:
--   This script initializes all required tables under the 'bronze' schema.
--   These tables store raw ingested data from ERP and CRM source systems.
-- ========================================

USE DataWarehouse;
GO

-- ========================================
-- CRM Tables
-- ========================================

-- Drop if exists, then create CRM Product Info Table
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO
CREATE TABLE bronze.crm_prd_info (
    prd_id        INT,
    prd_key       NVARCHAR(50),
    prd_nm        NVARCHAR(50),
    prd_cost      INT,
    prd_line      NVARCHAR(50),
    prd_start_dt  DATETIME,
    prd_end_dt    DATETIME
);
GO

-- Drop if exists, then create CRM Sales Details Table
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num   NVARCHAR(50),
    sls_prd_key   NVARCHAR(50),
    sls_cust_id   INT,
    sls_order_dt  INT,
    sls_ship_dt   INT,
    sls_due_dt    INT,
    sls_sales     INT,
    sls_quantity  INT,
    sls_price     INT
);
GO

-- Drop if exists, then create CRM Customer Info Table
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO
CREATE TABLE bronze.crm_cust_info (
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr           NVARCHAR(50),
    cst_create_date    DATE
);
GO

-- ========================================
-- ERP Tables
-- ========================================

-- Drop if exists, then create ERP Customer AZ12 Table
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO
CREATE TABLE bronze.erp_cust_az12 (
    cid   NVARCHAR(50),
    bdate DATE,
    gen   NVARCHAR(50)
);
GO

-- Drop if exists, then create ERP Location A101 Table
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO
CREATE TABLE bronze.erp_loc_a101 (
    cid   NVARCHAR(50),
    cntry NVARCHAR(50)
);
GO

-- Drop if exists, then create ERP Product Category G1V2 Table
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id          NVARCHAR(50),
    cat         NVARCHAR(50),
    subcat      NVARCHAR(50),
    maintenance NVARCHAR(50)
);
GO

-- ========================================
-- End of Bronze Table Creation Script
-- ========================================
PRINT 'Bronze schema tables created successfully.';