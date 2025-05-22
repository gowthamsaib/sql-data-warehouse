-- =========================================================================================
-- File:            ddl_gold.sql
-- Author:          Gowtham Sai Bhuvanam
-- Project:         SQL-Based ETL Pipeline & Analytics Architecture: CRM + ERP Integration
-- Layer:           Gold (Analytics & Reporting Layer)
--
-- Purpose:
--   - Define gold layer views (dimensions and facts) based on the silver layer.
--   - Transform, clean, and model data to support business intelligence and reporting.
--   - Establish surrogate keys and meaningful names for analytical use.
--
-- Expected Results:
--   - Dimensional views: dim_customers, dim_products
--   - Fact view: fact_sales with foreign keys to dimensions
-- =========================================================================================


-- ========================================
-- Create Dimension: Customers
-- ========================================
-- Rename columns to friendly, meaningful names
-- Sort columns into logical groups for readability
-- Surrogate key: System-generated unique identifier for each record
-- Source: silver.crm_cust_info + erp_cust_az12 + erp_loc_a101

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,        -- Surrogate key
    ci.cst_id AS customer_id,                                   -- Business key
    ci.cst_key AS customer_number,                              -- External system ID
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    el.cntry AS country,
    ci.cst_marital_status AS marital_status,
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr              -- CRM is master for gender
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,
    ca.bdate AS birthdate,
    ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 el ON ci.cst_key = el.cid;


-- ========================================
-- Create Dimension: Products
-- ========================================
-- Filter for current product info only (prd_end_dt is null)
-- Rename columns for clarity and sort logically
-- Surrogate key: Row number
-- Source: silver.crm_prd_info + erp_px_cat_g1v2

CREATE VIEW gold.dim_products AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
    pn.prd_id AS product_id,
    pn.prd_key AS product_number,
    pn.prd_nm AS product_name,
    pn.cat_id AS category_id,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance,
    pn.prd_cost AS cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;   -- Current data only


-- ========================================
-- Create Fact Table: Sales
-- ========================================
-- Contains measures and foreign keys to customer and product dimensions
-- Rename and reorder columns for clarity
-- Source: silver.crm_sales_details
-- Joins: gold.dim_products, gold.dim_customers (via business keys)

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num AS order_number,
    pr.product_key,      -- FK to dim_products
    ct.customer_key,     -- FK to dim_customers
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS shipping_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers ct ON sd.sls_cust_id = ct.customer_id;