#  Data Catalog for Silver Layer

## Overview

The **Silver Layer** represents cleaned and enriched data sourced from the Bronze Layer. It includes transformed tables that standardize naming, fix data quality issues, and normalize attributes. This layer serves as the foundation for building analytical models in the Gold Layer.

---

##  `silver.crm_cust_info`

**Purpose:** Cleaned and deduplicated customer records with standardized gender and marital status.

| Column Name          | Data Type    | Description                                            |
| -------------------- | ------------ | ------------------------------------------------------ |
| cst\_id              | INT          | Unique customer ID.                                    |
| cst\_key             | NVARCHAR(50) | CRM external customer key.                             |
| cst\_firstname       | NVARCHAR(50) | Trimmed first name.                                    |
| cst\_lastname        | NVARCHAR(50) | Trimmed last name.                                     |
| cst\_marital\_status | NVARCHAR(50) | Normalized marital status (e.g., 'Single', 'Married'). |
| cst\_gndr            | NVARCHAR(50) | Normalized gender (e.g., 'Male', 'Female').            |
| cst\_create\_date    | DATE         | Customer creation date.                                |
| sdw\_create\_date    | DATETIME2    | Data warehouse record creation timestamp.              |

---

##  `silver.crm_prd_info`

**Purpose:** Parsed and standardized product data with categorized IDs and computed end dates.

| Column Name       | Data Type    | Description                                         |
| ----------------- | ------------ | --------------------------------------------------- |
| prd\_id           | INT          | Unique product ID.                                  |
| cat\_id           | NVARCHAR(50) | Derived category ID from product key.               |
| prd\_key          | NVARCHAR(50) | Standardized product key.                           |
| prd\_nm           | NVARCHAR(50) | Product name.                                       |
| prd\_cost         | INT          | Cleaned and validated cost value.                   |
| prd\_line         | NVARCHAR(50) | Normalized product line (e.g., 'Mountain', 'Road'). |
| prd\_start\_dt    | DATE         | Product availability start date.                    |
| prd\_end\_dt      | DATE         | Derived end date using LEAD() function.             |
| sdw\_create\_date | DATETIME2    | Data warehouse record creation timestamp.           |

---

##  `silver.crm_sales_details`

**Purpose:** Cleaned sales transaction data with valid dates and corrected pricing logic.

| Column Name       | Data Type    | Description                               |
| ----------------- | ------------ | ----------------------------------------- |
| sls\_ord\_num     | NVARCHAR(50) | Sales order number.                       |
| sls\_prd\_key     | NVARCHAR(50) | Reference to product dimension key.       |
| sls\_cust\_id     | INT          | Reference to customer dimension key.      |
| sls\_order\_dt    | DATE         | Cleaned and converted order date.         |
| sls\_ship\_dt     | DATE         | Cleaned and converted shipping date.      |
| sls\_due\_dt      | DATE         | Cleaned and converted due date.           |
| sls\_sales        | INT          | Validated or derived total sales amount.  |
| sls\_quantity     | INT          | Number of units sold.                     |
| sls\_price        | INT          | Recalculated or cleaned unit price.       |
| sdw\_create\_date | DATETIME2    | Data warehouse record creation timestamp. |

---

##  `silver.erp_cust_az12`

**Purpose:** Cleaned ERP demographic data for customers.

| Column Name       | Data Type    | Description                                  |
| ----------------- | ------------ | -------------------------------------------- |
| cid               | NVARCHAR(50) | Customer ID reference.                       |
| bdate             | DATE         | Validated birthdate (future dates removed).  |
| gen               | NVARCHAR(50) | Normalized gender ('Male', 'Female', 'n/a'). |
| sdw\_create\_date | DATETIME2    | Data warehouse record creation timestamp.    |

---

##  `silver.erp_loc_a101`

**Purpose:** Standardized location data for ERP customers.

| Column Name       | Data Type    | Description                               |
| ----------------- | ------------ | ----------------------------------------- |
| cid               | NVARCHAR(50) | Customer ID reference.                    |
| cntry             | NVARCHAR(50) | Standardized country name.                |
| sdw\_create\_date | DATETIME2    | Data warehouse record creation timestamp. |

---

##  `silver.erp_px_cat_g1v2`

**Purpose:** Normalized product category and maintenance information.

| Column Name       | Data Type    | Description                               |
| ----------------- | ------------ | ----------------------------------------- |
| id                | NVARCHAR(50) | Product category ID.                      |
| cat               | NVARCHAR(50) | Product category name.                    |
| subcat            | NVARCHAR(50) | Product sub-category.                     |
| maintenance       | NVARCHAR(50) | Maintenance flag ('Yes', 'No').           |
| sdw\_create\_date | DATETIME2    | Data warehouse record creation timestamp. |