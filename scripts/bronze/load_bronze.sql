-- ====================================================================================================
-- File:           load_bronze.sql
-- Location:       scripts/bronze/load_bronze.sql
-- Author:         Gowtham Sai Bhuvanam
-- Created On:     5/14/2025
-- Project:        Data Warehouse & Analytics Project (Medallion Architecture)
--
-- Procedure Name: bronze.load_bronze
--
-- Purpose:
--   - This stored procedure loads raw data from CSV files into the 'bronze' layer tables.
--   - The bronze layer holds unprocessed source data from ERP and CRM systems.
--   - Each table is truncated before being reloaded to ensure a fresh snapshot.
--   - Time taken to load each table is measured and printed for monitoring purposes.
--
-- What it Does:
--   - Truncates and reloads 6 bronze tables:
--     • bronze.crm_cust_info
--     • bronze.crm_prd_info
--     • bronze.crm_sales_details
--     • bronze.erp_cust_az12
--     • bronze.erp_loc_a101
--     • bronze.erp_px_cat_g1v2
--   - Uses BULK INSERT with options: FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK
--   - Wraps entire operation in TRY...CATCH block to handle and display errors.
--   - Prints load duration for each individual table and total runtime for the bronze layer.
--
-- Parameters:
--   - None
--
-- To Execute:
--   EXEC bronze.load_bronze;
--
-- Output:
--   - Console output with detailed logs for each table:
--     • Truncation confirmation
--     • Insertion confirmation
--     • Load duration in seconds
--   - Final confirmation message on successful load
--   - Error message block if any failure occurs during the process
--
-- Assumptions:
--   - The CSV files exist at the specified file paths on the machine where SQL Server is hosted.
--   - File paths must be accessible to SQL Server (check SQL Server service account permissions).
--   - CSV files have headers in the first row.
-- ====================================================================================================

USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @start_time DATETIME, @end_time DATETIME, @bronze_start_time DATETIME, @bronze_end_time DATETIME;

    BEGIN TRY
        SET @bronze_start_time = GETDATE();
        PRINT '---------------------------------------------------------------';
        PRINT 'LOADING BRONZE LAYER';
        PRINT '---------------------------------------------------------------';

        -- ================================
        -- Load CRM Tables
        -- ================================
        PRINT '------------------------------------------------------';
        PRINT 'LOADING CRM TABLES';
        PRINT '------------------------------------------------------';

        -- CRM Customer Info
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> Inserting data to: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\small\Desktop\sql-data-warehouse\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ---------------------------';

        -- CRM Product Info
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Inserting data to: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\small\Desktop\sql-data-warehouse\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ---------------------------';

        -- CRM Sales Details
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Inserting data to: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\small\Desktop\sql-data-warehouse\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ---------------------------';

        -- ================================
        -- Load ERP Tables
        -- ================================
        PRINT '------------------------------------------------------';
        PRINT 'LOADING ERP TABLES';
        PRINT '------------------------------------------------------';

        -- ERP Customer
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Inserting data to: bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\small\Desktop\sql-data-warehouse\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ---------------------------';

        -- ERP Location
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> Inserting data to: bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\small\Desktop\sql-data-warehouse\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ---------------------------';

        -- ERP Product Category
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Inserting data to: bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\small\Desktop\sql-data-warehouse\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ---------------------------';

        -- Summary
        SET @bronze_end_time = GETDATE();
        PRINT '----------------------------------------------------';
        PRINT '✅ Loading Bronze Layer Completed';
        PRINT '  - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @bronze_start_time, @bronze_end_time) AS NVARCHAR) + ' seconds';
        PRINT '----------------------------------------------------';

    END TRY
    BEGIN CATCH
        PRINT '=====================================================';
        PRINT '❌ ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number:  ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State:   ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '=====================================================';
    END CATCH
END;
GO