# 🔠 Naming Conventions for Data Warehouse Objects

This guide defines consistent naming standards across all layers—Bronze, Silver, and Gold—in the data warehouse. The goal is to promote clarity, reduce ambiguity, and align with best practices in data modeling.

---

## Table of Contents

* Core Guidelines
* Table Naming by Layer

  * Bronze Layer
  * Silver Layer
  * Gold Layer
* Column Naming Guidelines

  * Surrogate Keys
  * Technical Metadata Columns
* Stored Procedure Pattern

---

##  Core Guidelines

* **Style:** Use `snake_case` (lowercase letters and underscores).
* **Language:** Always use English.
* **Reserved Keywords:** Avoid using SQL reserved words as object identifiers.

---

##  Table Naming by Layer

###  Bronze Layer

* Format: `{source}_{entity}`
* Rule: Names must begin with the originating system name and match the original source table without alteration.
* Components:

  * `source`: Abbreviation of source system (e.g., `crm`, `erp`)
  * `entity`: Exact table name from source
* Example: `crm_customer_info` → Raw CRM customer data

###  Silver Layer

* Format: `{source}_{entity}`
* Rule: Follow the same conventions as Bronze. Names remain unchanged from their source.
* Example: `erp_sales_data` → ERP transactional sales records

###  Gold Layer

* Format: `{role}_{subject}`
* Rule: Use business-aligned and descriptive names.
* Prefix meanings:

  * `dim_`: Dimension table
  * `fact_`: Fact table
  * `report_`: Reporting-ready aggregate or derived table
* Examples:

  * `dim_customers`: Business-level customer attributes
  * `fact_sales`: Transactional sales facts
  * `report_monthly_revenue`: Aggregated monthly revenue report

---

##  Column Naming Guidelines

###  Surrogate Keys

* Format: `{entity}_key`
* Rule: All dimension tables should have a primary surrogate key using this format.
* Example: `customer_key` → Primary key in `dim_customers`

###  Technical Metadata Columns

* Format: `dwh_{metric}`
* Rule: All system-generated or operational metadata columns should start with `dwh_`
* Examples:

  * `dwh_create_date` → Timestamp when data was loaded
  * `dwh_source_file` → Filename or source record path

---

##  Stored Procedures

### Naming Format:

* `load_{layer}`

Where:

* `layer` = `bronze`, `silver`, or `gold`

### Examples:

* `load_bronze` → Procedure to load raw data into Bronze layer
* `load_silver` → Procedure to process data into Silver layer

---

By following this structure, the warehouse remains predictable, maintainable, and scalable for teams across engineering, analytics, and reporting.