# 🏢 Data Warehouse & Analytics Project

Welcome to the **Data Warehouse & Analytics Project** repository! 🚀  
This portfolio project showcases the end-to-end implementation of a modern data warehouse and analytics solution. It highlights data engineering best practices, efficient data modeling techniques, and actionable business intelligence using SQL and visualization tools.

---

## 🧱 Data Architecture – Medallion Design

The project follows the **Medallion Architecture** with three key layers:

- **🔶 Bronze Layer**: Stores raw data ingested as-is from the source systems (ERP and CRM) via CSV files into SQL Server.
- **⚪ Silver Layer**: Transforms, cleanses, and standardizes the raw data for analytical usability.
- **🔷 Gold Layer**: Final business-ready layer modeled in a **Star Schema** for reporting and analysis.

---

## 📌 Project Overview

This project demonstrates:

- **Data Architecture** using modern warehousing principles
- **ETL Pipelines** to extract, transform, and load data into SQL Server
- **Data Modeling** with Fact and Dimension tables for analytics
- **Analytics & Reporting** using SQL queries and BI dashboards to generate insights

---

## 🎯 Objectives

### 📦 Data Engineering Goals:
- Design and implement a scalable warehouse in SQL Server.
- Integrate data from two source systems (ERP & CRM).
- Ensure data quality through cleansing and transformation.
- Model analytical data in a star schema format.
- Document the entire pipeline and model for stakeholder usage.

### 📊 Analytics Goals:
- Derive insights on:
  - Customer behavior
  - Product performance
  - Sales trends
- Create SQL-based reports to support strategic business decisions.

---

## 🛠️ Tools & Resources Used

| Tool                | Purpose                                      |
|---------------------|----------------------------------------------|
| SQL Server Express  | Database for data warehouse                  |
| SSMS                | Database interaction and management          |
| Draw.io             | Data flow, architecture, and schema diagrams |
| Notion              | Project management and task tracking         |
| GitHub              | Version control and collaboration            |
| Tableau (Optional)  | BI dashboarding (optional visualization)     |

---

## 📂 Repository Structure

data-warehouse-project/
│
├── datasets/ # ERP and CRM raw data (CSV files)
│
├── docs/ # Project documentation and diagrams
│ ├── data_architecture.drawio # Architecture design (Medallion model)
│ ├── etl.drawio # ETL pipeline visualizations
│ ├── data_flow.drawio # Data flow overview
│ ├── data_models.drawio # Star schema data models
│ ├── data_catalog.md # Metadata and data dictionary
│ ├── naming-conventions.md # Naming standards
│
├── scripts/ # SQL Scripts
│ ├── bronze/ # Data ingestion scripts
│ ├── silver/ # Transformation & cleansing scripts
│ ├── gold/ # Data modeling & aggregation scripts
│
├── tests/ # Data quality checks and test queries
│
├── README.md # This file
├── .gitignore # Git ignored files
└── requirements.txt # Project dependencies (optional)


---

## 📊 Sample Business Questions Answered

- Which customer segments generate the most revenue?
- What are the top-selling products by region?
- How do sales trends vary month-over-month?
- What CRM leads converted into actual purchases?

---

## 🧪 Test & Validation

To ensure accuracy and quality, the project includes:
- Null and duplicates checks
- Data type validations
- Referential integrity tests

---

## 📝 License

This project is open-source under the **MIT License**.  
Feel free to use, modify, and share with proper attribution.

---

## 🙌 About the Author

Hi! I’m **Gowtham Sai Bhuvanam**, an aspiring Data Engineer and Analyst passionate about turning raw data into insights. This project demonstrates my skills in ETL design, data modeling, and SQL analytics as part of my professional portfolio.

📌 [LinkedIn](https://linkedin.com/in/gowthamsaib)  
🌐 [Portfolio (Coming Soon)]()  
🎓 MS in Artificial Intelligence and Business Analytics @ USF (May 2025)

---

## 📬 Let's Connect!

Feel free to star ⭐ this repo and connect with me. I’d love to learn, collaborate, and grow with the data community!