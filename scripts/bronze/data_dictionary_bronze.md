#  Data Catalog for Bronze Layer

## Overview

The **Bronze Layer** stores raw, unprocessed data ingested directly from source systems such as ERP and CRM. It serves as the foundational layer in the Medallion Architecture, preserving data integrity and traceability before any cleaning or transformation occurs.

---

##  `bronze.crm_cust_info`

**Purpose:** Raw customer master data from CRM source.

| Column Name          | Data Type    | Description                                  |
| -------------------- | ------------ | -------------------------------------------- |
| cst\_id              | INT          | Unique customer identifier.                  |
| cst\_key             | NVARCHAR(50) | External key used for identifying customers. |
| cst\_firstname       | NVARCHAR(50) | First name of the customer.                  |
| cst\_lastname        | NVARCHAR(50) | Last name or surname of the customer.        |
| cst\_marital\_status | NVARCHAR(50) | Marital status code ('M', 'S', etc.).        |
| cst\_gndr            | NVARCHAR(50) | Gender code ('M', 'F', etc.).                |
| cst\_create\_date    | DATE         | Customer creation date.                      |

---

##  `bronze.crm_prd_info`

**Purpose:** Raw product data including pricing, category keys, and lifecycle dates.

| Column Name    | Data Type    | Description                             |
| -------------- | ------------ | --------------------------------------- |
| prd\_id        | INT          | Unique product ID.                      |
| prd\_key       | NVARCHAR(50) | Encoded product key with category info. |
| prd\_nm        | NVARCHAR(50) | Product name as captured in CRM.        |
| prd\_cost      | INT          | Original cost or price of the product.  |
| prd\_line      | NVARCHAR(50) | Product line or segment code.           |
| prd\_start\_dt | DATE         | Product availability start date.        |
| prd\_end\_dt   | DATE         | Product end-of-life date.               |

---

##  `bronze.crm_sales_details`

**Purpose:** Raw sales transaction records from CRM.

| Column Name    | Data Type    | Description                                       |
| -------------- | ------------ | ------------------------------------------------- |
| sls\_ord\_num  | NVARCHAR(50) | Sales order number.                               |
| sls\_prd\_key  | NVARCHAR(50) | Reference key for the product in the transaction. |
| sls\_cust\_id  | INT          | Customer ID associated with the sale.             |
| sls\_order\_dt | INT          | Order date in integer format (e.g., 20210115).    |
| sls\_ship\_dt  | INT          | Shipping date (integer format).                   |
| sls\_due\_dt   | INT          | Payment due date (integer format).                |
| sls\_sales     | INT          | Total sales amount for the order line.            |
| sls\_quantity  | INT          | Number of product units sold.                     |
| sls\_price     | INT          | Price per unit of the product.                    |

---

##  `bronze.erp_cust_az12`

**Purpose:** Customer demographic information from ERP.

| Column Name | Data Type    | Description                     |
| ----------- | ------------ | ------------------------------- |
| cid         | NVARCHAR(50) | Customer identifier in ERP.     |
| bdate       | DATE         | Customer's date of birth.       |
| gen         | NVARCHAR(50) | Gender representation from ERP. |

---

##  `bronze.erp_loc_a101`

**Purpose:** Customer location mapping from ERP system.

| Column Name | Data Type    | Description                      |
| ----------- | ------------ | -------------------------------- |
| cid         | NVARCHAR(50) | Customer ID linking to location. |
| cntry       | NVARCHAR(50) | Country code or name.            |

---

##  `bronze.erp_px_cat_g1v2`

**Purpose:** ERP product classification and maintenance requirements.

| Column Name | Data Type    | Description                             |
| ----------- | ------------ | --------------------------------------- |
| id          | NVARCHAR(50) | Product category identifier.            |
| cat         | NVARCHAR(50) | Broad category name (e.g., 'Bikes').    |
| subcat      | NVARCHAR(50) | Subcategory name (e.g., 'Helmets').     |
| maintenance | NVARCHAR(50) | Maintenance required flag ('Yes'/'No'). |
