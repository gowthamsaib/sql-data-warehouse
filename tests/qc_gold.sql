-- =========================================================================================
-- File:            qc_gold.sql
-- Author:          Gowtham Sai Bhuvanam
-- Project:         SQL-Based ETL Pipeline & Analytics Architecture: CRM + ERP Integration
-- Layer:           Gold (Analytics & Reporting Layer)
--
-- Purpose:
--   - Perform data quality checks on gold layer views.
--   - Validate surrogate key uniqueness, data consistency, and referential integrity.
-- =========================================================================================


-- ========================================
-- Quality Checks: Dimension Customers
-- ========================================

-- Check for duplicates after joining customer tables
SELECT cst_id, COUNT(*) 
FROM (
    SELECT
        ci.cst_id,
        ci.cst_key,
        ci.cst_firstname,
        ci.cst_lastname,
        ci.cst_marital_status,
        ci.cst_gndr,
        ci.cst_create_date,
        ca.bdate,
        ca.gen,
        el.cntry
    FROM silver.crm_cust_info ci
    LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.cid
    LEFT JOIN silver.erp_loc_a101 el ON ci.cst_key = el.cid
) t
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- Check gender resolution logic based on master source (CRM)
-- NULLs come from joined tables when SQL finds no match
SELECT DISTINCT
    ci.cst_gndr,
    ca.gen,
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS resolved_gender
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 el ON ci.cst_key = el.cid
ORDER BY 1, 2;


-- ========================================
-- Quality Checks: Dimension Products
-- ========================================

-- Check for duplicates after joining product and category tables
SELECT prd_key, COUNT(*) 
FROM (
    SELECT 
        pn.prd_id,
        pn.cat_id,
        pn.prd_key,
        pn.prd_nm,
        pn.prd_cost,
        pn.prd_line,
        pn.prd_start_dt,
        pc.cat,
        pc.subcat,
        pc.maintenance
    FROM silver.crm_prd_info pn
    LEFT JOIN silver.erp_px_cat_g1v2 pc ON pn.cat_id = pc.id
    WHERE pn.prd_end_dt IS NULL
) t
GROUP BY prd_key
HAVING COUNT(*) > 1;


-- ========================================
-- Quality Checks: Fact Sales
-- ========================================

-- Check for foreign key integrity by verifying dimension joins
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
WHERE c.customer_key IS NULL OR p.product_key IS NULL;