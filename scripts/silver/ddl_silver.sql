-- ======================================================================================
-- File:            ddl_silver.sql
-- Author:          Gowtham Sai Bhuvanam
-- Project:         Data Warehouse & Analytics Project
-- Layer:           Silver
-- Purpose:         
--   - Defines the cleaned and transformed table structures for the 'silver' schema.
--   - Each table is sourced from corresponding bronze/raw tables.
--   - A default load timestamp column 'sdw_create_date' is included for auditing.
--   - All tables are dropped if they exist to ensure fresh rebuilds during development.
--
-- Note:
--   - 'silver' layer holds data that is transformed, standardized, and ready for analytics.
-- ======================================================================================

USE DataWarehouse;
GO

-- ======================================================
-- 1. CRM Customer Information Table
-- ======================================================
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info (
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr           NVARCHAR(50),
    cst_create_date    DATE,
    sdw_create_date    DATETIME2 DEFAULT GETDATE()  -- Silver Data Warehouse Load Timestamp
);
GO

-- ======================================================
-- 2. CRM Product Information Table
-- ======================================================
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
    prd_id          INT,
    cat_id          NVARCHAR(50),  -- Derived from prd_key (first 5 chars)
    prd_key         NVARCHAR(50),
    prd_nm          NVARCHAR(50),
    prd_cost        INT,
    prd_line        NVARCHAR(50),  -- Transformed into readable product line names
    prd_start_dt    DATE,
    prd_end_dt      DATE,          -- Derived using LEAD function on prd_start_dt
    sdw_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- ======================================================
-- 3. CRM Sales Details Table
-- ======================================================
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    sls_ord_num     NVARCHAR(50),
    sls_prd_key     NVARCHAR(50),
    sls_cust_id     INT,
    sls_order_dt    DATE,         -- Converted from INT to DATE during transformation
    sls_ship_dt     DATE,
    sls_due_dt      DATE,
    sls_sales       INT,
    sls_quantity    INT,
    sls_price       INT,
    sdw_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- ======================================================
-- 4. ERP Customer Details Table
-- ======================================================
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
GO

CREATE TABLE silver.erp_cust_az12 (
    cid             NVARCHAR(50),
    bdate           DATE,
    gen             NVARCHAR(50),
    sdw_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- ======================================================
-- 5. ERP Location Table
-- ======================================================
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO

CREATE TABLE silver.erp_loc_a101 (
    cid             NVARCHAR(50),
    cntry           NVARCHAR(50),
    sdw_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- ======================================================
-- 6. ERP Product Category Table
-- ======================================================
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
GO

CREATE TABLE silver.erp_px_cat_g1v2 (
    id              NVARCHAR(50),
    cat             NVARCHAR(50),
    subcat          NVARCHAR(50),
    maintenance     NVARCHAR(50),
    sdw_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- Silver layer tables created successfully.
PRINT 'All silver schema tables have been created.';