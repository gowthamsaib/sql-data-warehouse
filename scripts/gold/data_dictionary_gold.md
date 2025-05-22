# Data Dictionary for Gold Layer

## Overview

The **Gold Layer** represents the business-ready, analytical view of the data warehouse. It includes dimensional and fact views structured to support efficient reporting, dashboarding, and data-driven decision-making.

---

## gold.dim\_customers

**Purpose:**
Stores customer master data enriched with demographic (birthdate, gender) and geographic (country) information. Serves as a dimension table for sales analysis.

| Column Name      | Data Type    | Description                                                     |
| ---------------- | ------------ | --------------------------------------------------------------- |
| customer\_key    | INT          | Surrogate key uniquely identifying each customer record.        |
| customer\_id     | INT          | Business ID assigned to each customer (from CRM).               |
| customer\_number | NVARCHAR(50) | External alphanumeric identifier for customer tracking.         |
| first\_name      | NVARCHAR(50) | Customer's first name.                                          |
| last\_name       | NVARCHAR(50) | Customer's last name or family name.                            |
| country          | NVARCHAR(50) | Country of residence (e.g., 'Australia').                       |
| marital\_status  | NVARCHAR(50) | Marital status (e.g., 'Single', 'Married').                     |
| gender           | NVARCHAR(50) | Standardized gender value (e.g., 'Male', 'Female', 'n/a').      |
| birthdate        | DATE         | Date of birth (format: YYYY-MM-DD).                             |
| create\_date     | DATE         | Date when the customer record was created in the source system. |

---

## gold.dim\_products

**Purpose:**
Captures product-level details for inventory, pricing, and category analysis. Used as a product dimension in sales reporting.

| Column Name     | Data Type    | Description                                                        |
| --------------- | ------------ | ------------------------------------------------------------------ |
| product\_key    | INT          | Surrogate key for each product record.                             |
| product\_id     | INT          | Internal product ID.                                               |
| product\_number | NVARCHAR(50) | Structured product code (used in sales and inventory).             |
| product\_name   | NVARCHAR(50) | Full product name with attributes (e.g., type, color, size).       |
| category\_id    | NVARCHAR(50) | Identifier used to classify the product at a high level.           |
| category        | NVARCHAR(50) | Broad category group (e.g., Bikes, Components).                    |
| subcategory     | NVARCHAR(50) | Specific product sub-type.                                         |
| maintenance     | NVARCHAR(50) | Indicates if the product requires maintenance (e.g., 'Yes', 'No'). |
| cost            | INT          | Base cost or price of the product.                                 |
| product\_line   | NVARCHAR(50) | Product series or line (e.g., Mountain, Road).                     |
| start\_date     | DATE         | Launch date of the product (when it became available for sale).    |

---

## gold.fact\_sales

**Purpose:**
Contains transaction-level sales facts and connects to customer and product dimensions for analytical aggregation.

| Column Name    | Data Type    | Description                                                    |
| -------------- | ------------ | -------------------------------------------------------------- |
| order\_number  | NVARCHAR(50) | Unique order reference for each transaction (e.g., 'SO54496'). |
| product\_key   | INT          | Foreign key to the product dimension (`dim_products`).         |
| customer\_key  | INT          | Foreign key to the customer dimension (`dim_customers`).       |
| order\_date    | DATE         | Date the order was placed.                                     |
| shipping\_date | DATE         | Date the order was shipped.                                    |
| due\_date      | DATE         | Date payment was due.                                          |
| sales\_amount  | INT          | Total monetary value of the sale in whole currency units.      |
| quantity       | INT          | Quantity of units sold.                                        |
| price          | INT          | Unit price of the product.                                     |

---

**Note:** Surrogate keys are used in the gold layer to maintain consistency and simplify joins for analytics. All views follow star schema modeling principles.