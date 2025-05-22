-- =========================================================================================
-- File:            qc_silver.sql
-- Author:          Gowtham Sai Bhuvanam
-- Project:         SQL-Based ETL Pipeline & Analytics Architecture: CRM + ERP Integration
-- Layer:           Silver (Cleaned/Transformed Data Layer)
--
-- Purpose:
--   - Validate data quality across Silver layer tables.
--   - Ensure conformance with business rules, referential integrity, and standardization.
--
-- Expected Results:
--   - No NULLs or duplicates in keys
--   - Consistent categorical values
--   - Valid and logical date values
--   - Referential integrity between foreign keys
-- =========================================================================================


-- Quality Checks - crm_cust_info
-- A Primary Key must be unique and not null

-- Check for Nulls or Duplicates in the Primary Key
-- Expectation: No Results

select cst_id, count(*)
from silver.crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null;

-- Check for unwanted Spaces
-- No Results
select cst_firstname
from silver.crm_cust_info
where cst_firstname != TRIM(cst_firstname);

select cst_lastname
from silver.crm_cust_info
where cst_lastname != TRIM(cst_lastname);

select cst_gndr
from silver.crm_cust_info
where cst_gndr != TRIM(cst_gndr);

-- Data Standardization & Consistency
select distinct cst_gndr
from silver.crm_cust_info;

select distinct cst_marital_status
from silver.crm_cust_info;

-- Quality Checks - crm_prd_info
-- A Primary Key must be unique and not null

-- Check for Nulls or Duplicates in the Primary Key
-- Expectation: No Results

select prd_id, count(*)
from silver.crm_prd_info
group by prd_id
having count(*) > 1 or prd_id is null;

-- Splitting the prd_key into cat_id & prd_id
-- So that we can join 
		--1) cat_id from cust_prd_info & id from erp_px_cat_g1v2
		--2) prd_id from cust_prd_info & sls_prd_key from cr_sales_details

-- To check whether cat_id from cust_prd_info & id from erp_px_cat_g1v2 are same
-- We need make '-' into '_'
select distinct id from silver.erp_px_cat_g1v2; 

-- Below filters out unmatched data after applying transfomation
select 
	prd_key,
	replace(substring(prd_key,1,5),'-','_') as cat_id
from silver.crm_prd_info
where replace(substring(prd_key,1,5),'-','_') not in (
select distinct id from silver.erp_px_cat_g1v2)

select 
	replace(substring(prd_key,1,5),'-','_') as cat_id,
	substring(prd_key, 7, len(prd_key)) as prd_key
from silver.crm_prd_info
where substring(prd_key, 7, len(prd_key)) in (
select sls_prd_key from silver.crm_sales_details)

-- Check for unwanted Spaces
-- No Results
select prd_nm
from silver.crm_prd_info
where prd_nm != TRIM(prd_nm);

-- Checking for nulls or any negative numbers
-- No Results
select prd_cost
from silver.crm_prd_info
where prd_cost < 0 or prd_cost is null;

-- Data Standardization & Consistency
select distinct prd_line
from silver.crm_prd_info;

-- Check for Invalid Date Orders
-- End date must not be earlier than the start date
select * 
from silver.crm_prd_info
where prd_end_dt < prd_start_dt

		-- Got some invalid date orders
		-- So for complex transfprmations in SQL,
		-- Typically narrow it down to a specific example & brainstrom multiple solution approaches.

		-- Sol 1: Switch end_date and start_date ---> Dates overlapping
		-- Sol 2: Derive end_date with start_date
			-- Issue: Each record must have a start_date
			-- End_date: Start_date of the 'next' record - 1
select 
prd_id,
prd_key,
prd_nm,
prd_start_dt,
prd_end_dt,
lead(prd_start_dt) over (partition by prd_key order by prd_start_dt)-1 as prd_end_dt_test
from silver.crm_prd_info
where prd_key in ('AC-HE-HL-U509-R', 'AC-HE-HL-U509');

-- Quality Checks - crm_sales_details
select * from silver.crm_sales_details;

-- Check for unwanted Spaces
-- No Results
select sls_ord_num
from silver.crm_sales_details
where sls_ord_num != TRIM(sls_ord_num); 


-- These are key & id which we use to connect the tables
-- See intergration model.png
select sls_prd_key
from silver.crm_sales_details
where sls_prd_key not in (select prd_key from silver.crm_prd_info); -- Should not return anything

select sls_cust_id
from silver.crm_sales_details
where sls_cust_id not in (select cst_id from silver.crm_cust_info); -- Should not return anything

-- Here the dates were in datatype: int
-- Cast them to approriate dates

-- Negative numbers or zeros can't be cast to date
select sls_order_dt
from bronze.crm_sales_details
where sls_order_dt <= 0
-- Found some zeros converted into Nulls

-- Check for Invalid Dates
-- In this case, the len of the date must be 8 (since its in the order year,month, day. Eg: 20101229)
-- Also check for outliners by validating the boundaries of date range 
select 
nullif (sls_ship_dt,0) sls_ship_dt
from bronze.crm_sales_details
where sls_ship_dt <= 0 
	or len(sls_ship_dt) !=8
	or sls_ship_dt >20500101
	or sls_ship_dt > 19000101;

-- Check or invalid date orders
-- Order date must always br earlier than the shipping date or due date
-- Look good.
select 
*
from silver.crm_sales_details
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt

--Business Rules
	-- Sum of sales = Qualtity * Price
	-- Negative, zeros, nulls are not allowed
	-- Hence found some cases where they are true, Need to discuss with Busniess experts
		-- # Solution 1 : Data Issues will be fixed direct in source system
		-- # Solution 2 : Data Issues has to be fixed in data warehouse
			-- Rules:
				-- 1) If sales is negative, zero, or null, derive it using Quantity and Price
				-- 2) If price is zero or null, calculate it using Sales & Quantity
				-- 3) If price is negative, convert it into positive value
select 
sls_sales,
sls_quantity,
sls_price
from bronze.crm_sales_details
where sls_sales != sls_quantity * sls_price
	or sls_sales is null or sls_quantity is null or sls_price is null
	or sls_sales <=0 or sls_quantity <=0 or sls_price <=0
order by sls_sales, sls_quantity, sls_price

select 
	sls_sales as old_sls_sales,
		case when sls_sales is null or sls_sales<=0 or sls_sales != sls_quantity * ABS(sls_price)
			then sls_quantity * ABS(sls_price)
		else sls_sales
	end  as sls_sales,
	sls_quantity,
	sls_price as old_sls_price,
	case when sls_price is null or sls_price <= 0
			then sls_sales / nullif(sls_quantity,0)
		else sls_price
	end  as sls_price
from bronze.crm_sales_details
where sls_sales != sls_quantity * sls_price
or sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales <=0 or sls_quantity <=0 or sls_price <=0

select * from silver.crm_sales_details

-- Quality Checks - erp_cust_az12

-- cid looks like, to connect the tables
-- See intergration model.png
-- But has some extra characters ('NAS' at the start)
select 
	case when cid like 'NAS%' then substring(cid, 4, len(cid))
		 else cid
	end as cid
from bronze.erp_cust_az12;

-- Identify Out-of-Range Birthday Dates
-- Check for past dates like from 1924-01-01 --> look good
-- Check for any future dates - should be no results --> Found some like '2045-03-03', '9999-09-11' etc
	-- Totally Unacceptable & Bad Quality Data must report to source system to correct it
	-- Replace them as 'NULL' in Data Warehouse
select distinct
	bdate,
	case when bdate > getdate() then NULL
		 else bdate
	end bdate
from bronze.erp_cust_az12
where bdate > '1924-01-01' or bdate > getdate();

-- Data standardization & Consistency
select distinct
	gen,
	case when upper(trim(gen)) in ('F', 'Female') then 'Female'
		 when upper(trim(gen)) in ('M', 'Male') then 'Male'
		 else 'n/a'
	end gen
from bronze.erp_cust_az12

select distinct gen from silver.erp_cust_az12
select bdate from silver.erp_cust_az12 where bdate > getdate();

select * from silver.erp_cust_az12

-- Quality Checks - erp_loc_a101

-- cid looks like, to connect the tables
-- See intergration model.png
-- But there is an extra character '-', need to remove that 

select 
	replace(cid,'-','') cid
from bronze.erp_loc_a101
where replace(cid,'-','') not in 
(select cst_key from silver.crm_cust_info)

-- Data standardization & Consistency
select distinct
	case when trim(cntry) = 'DE' then 'Germany'
		 when trim(cntry) in ('US', 'USA') then 'United States'
		 when trim(cntry) = '' or cntry is null then 'n/a'
		else trim(cntry)
	end as cntry
from bronze.erp_loc_a101

select * from silver.erp_loc_a101

-- Quality Checks - erp_px_cat_g1v2

-- id looks like, to connect the tables
-- See intergration model.png
select 
	id
from bronze.erp_px_cat_g1v2

select * from silver.crm_prd_info

-- Check for unwanted Spaces
-- No Results
select 
	cat,
	subcat,		
	maintenance
from bronze.erp_px_cat_g1v2		-- Everything looks good
where cat != TRIM(cat) or subcat != TRIM(subcat) or maintenance != TRIM(maintenance) 

-- Data Standardization & Consistency
select distinct
	maintenance
from bronze.erp_px_cat_g1v2		-- Everything looks good