# 🚀 Modern Data Warehouse – Supply Chain & Logistics Analytics

<p align="center">

[![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com/)
[![Azure Synapse](https://img.shields.io/badge/Azure_Synapse-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com/en-us/products/synapse-analytics)
[![Azure Data Factory](https://img.shields.io/badge/Azure_Data_Factory-FF6F00?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com/en-us/products/data-factory)
[![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![PySpark](https://img.shields.io/badge/PySpark-E25A1C?style=for-the-badge&logo=apachespark&logoColor=white)](https://spark.apache.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)](https://opensource.org/licenses/MIT)

</p>

<p align="center">
Enterprise-grade Modern Data Warehouse built on Microsoft Azure following the Medallion Architecture (Bronze → Silver → Gold) for Supply Chain & Logistics Analytics.
</p>

---

# 📖 Project Overview

This repository demonstrates a complete cloud-native Modern Data Warehouse implementation on Microsoft Azure.

The platform simulates a real enterprise Supply Chain Analytics use case by ingesting operational data exported from Oracle SCM Cloud into Azure Data Lake Storage Gen2, transforming it through a Medallion architecture, and serving analytics in Power BI via Synapse Serverless SQL.

This project was developed during my **PFA internship at Smartovate** as a **2nd-year Big Data Engineering cycle d’ingénieur** student.

---

# 🎯 Project Objectives

- Build an end-to-end Medallion Lakehouse architecture (Bronze → Silver → Gold)
- Automate data ingestion using Azure Data Factory
- Implement metadata-driven and parameterized pipelines
- Secure resources with Managed Identity + RBAC
- Store and manage secrets securely using Azure Key Vault
- Transform raw CSV files into analytics-ready Parquet datasets
- Build an incremental Gold layer with Star Schema modeling
- Deliver business dashboards in Power BI with performance optimization
- Implement monitoring and data quality visibility

---

# ✨ Features

- ✅ Azure Data Lake Storage Gen2
- ✅ Azure Data Factory V2
- ✅ Azure Synapse Analytics (Spark + Serverless SQL)
- ✅ Spark Notebooks (PySpark)
- ✅ Serverless SQL External Objects
- ✅ Azure Key Vault
- ✅ Managed Identity Authentication
- ✅ Azure RBAC
- ✅ Metadata-driven Pipelines
- ✅ Dynamic Parameters
- ✅ Medallion Architecture
- ✅ Star Schema Modeling
- ✅ Incremental Fact Loading (Partitioned Parquet)
- ✅ Power BI Integration (Hybrid Import + DirectQuery)
- ✅ Data Quality Gate + Monitoring Dashboard

---

# 👨‍💻 Author

| | |
|:--:|:--|
| <img src="https://github.com/TageYassir.png" width="120"/> | **Yassir Tagemouati** <br><br> Big Data Engineering Student (Cycle d’Ingénieur) <br> Azure Data Engineering • Data Warehousing • Analytics <br><br> **GitHub:** [@TageYassir](https://github.com/TageYassir) |

---

# 📚 Table of Contents

- [Project Architecture](#-project-architecture)
- [Repository Structure](#-repository-structure)
- [Tech Stack](#-tech-stack)
- [End-to-End Data Flow](#-end-to-end-data-flow)
- [Epic 1 – Infrastructure & Security](#-epic-1--infrastructure--security-)
- [Epic 2 – Data Ingestion & Orchestration](#-epic-2--data-ingestion--orchestration-)
- [Epic 3 – Transformation (Bronze → Silver → Gold)](#-epic-3--transformation-bronze--silver--gold-)
- [Epic 4 – Power BI Dashboards](#-epic-4--power-bi-dashboards-)
- [Epic 5 – Monitoring & Alerting](#-epic-5--monitoring--alerting-)
- [Roadmap](#-roadmap)
- [References](#-references)
- [License](#-license)

---

# 🏛️ Project Architecture

## Data Source
- Simulated **Oracle SCM Cloud CSV files**:
  - `suppliers.csv`
  - `purchase_orders.csv`
  - `deliveries.csv`
  - `inventory.csv`
- Uploaded to ADLS source container: `source-files`

## Storage
- ADLS Gen2 account: `stlakesupply`
- Container: `medallion`
- Folders:
  - `bronze/`
  - `silver/`
  - `gold/`
  - `control/`

## Ingestion
- Azure Data Factory: `adf-supplychain-1`
- Parameterized + metadata-driven pipelines
- Control-table-based orchestration

## Processing
- Azure Synapse Analytics: `syn-supplychain-1`
- Spark Pool: `sparkpool01` for Bronze → Silver
- Serverless SQL for Silver → Gold and semantic serving

## Serving
- Power BI connected to Synapse Serverless SQL (`gold_db`)
- Hybrid model:
  - Import for dimensions and aggregations
  - DirectQuery for detailed facts

## Security
- Managed Identity + RBAC
- Roles used:
  - Storage Blob Data Contributor
  - Synapse Contributor
  - db_owner

---

# 🖼️ Solution Diagrams

## Overall Azure Architecture

<p align="center">
<img src="images/AzureArch.drawio.png" width="100%">
</p>

<p align="center">
<b>Figure 1.</b> Enterprise Azure architecture implementing the Medallion Lakehouse.
</p>

## Data Ingestion Pipeline

<p align="center">
<img src="images/AzurePLFlow.drawio.png" width="100%">
</p>

<p align="center">
<b>Figure 2.</b> Azure Data Factory orchestration workflow.
</p>

## Gold Layer Star Schema

<p align="center">
<img src="images/GoldShema.drawio.png" width="100%">
</p>

<p align="center">
<b>Figure 3.</b> Business-oriented Star Schema used by Power BI.
</p>

---

# 📁 Repository Structure

```text
Azure_Cloud/
│
├── data/
├── images/
│   ├── AzureArch.drawio.png
│   ├── AzurePLFlow.drawio.png
│   └── GoldShema.drawio.png
├── notebooks/
├── sql/
├── pipelines/
├── docs/
└── README.md
```

---

# 🛠️ Tech Stack

| Layer | Technology |
|:------|:-----------|
| 💾 Storage | Azure Data Lake Storage Gen2 |
| 🔄 Orchestration | Azure Data Factory |
| ⚡ Processing | Azure Synapse Spark |
| 🧮 SQL | Synapse Serverless SQL |
| 🔐 Security | Azure Key Vault |
| 🔑 Authentication | Managed Identity |
| 📊 Reporting | Power BI |
| 🐍 Language | PySpark |
| ☁️ Cloud | Microsoft Azure |

---

# 🔄 End-to-End Data Flow

```text
Oracle SCM Cloud CSV Files
            │
            ▼
Azure Data Lake Storage (Bronze)
            │
            ▼
Azure Data Factory
            │
            ▼
Azure Synapse Spark
            │
            ▼
Silver Layer (Parquet)
            │
            ▼
Gold Layer (Star Schema + Facts)
            │
            ▼
Serverless SQL
            │
            ▼
Power BI Dashboards
```

---

# ✅ Epic 1 – Infrastructure & Security ✅ COMPLETED

All core resources were deployed and connected successfully.

## ☁️ Azure Resources

| Resource | Name | Region | Configuration |
|----------|------|--------|---------------|
| Azure Data Lake Storage Gen2 | `stlakesupply` | West Europe | Hierarchical Namespace, LRS, Cool Tier |
| Azure Data Factory | `adf-supplychain-1` | West Europe | Managed Identity |
| Azure Synapse Analytics | `syn-supplychain-1` | France Central | Spark + Serverless SQL |
| Azure Key Vault | `kv-supplychain-2026` | West Europe | Soft Delete Enabled |
| Spark Pool | `sparkpool01` | France Central | Spark 3.4, Auto Pause, Autoscale |

> **Note:** Synapse was deployed in France Central due to temporary student subscription capacity constraints in West Europe.

## 🔐 Security Implementation

| Resource | Role | Identity |
|----------|------|----------|
| ADLS Gen2 | Storage Blob Data Contributor | Azure Data Factory |
| ADLS Gen2 | Storage Blob Data Contributor | Azure Synapse |
| Synapse Workspace | Synapse Contributor | Azure Data Factory |
| SQL Database | db_owner | Azure Data Factory |

### Security Best Practices Applied
- Managed Identities only
- No hardcoded credentials
- Azure RBAC
- Principle of least privilege
- Key Vault integration
- Secret rotation readiness

---

# ✅ Epic 2 – Data Ingestion & Orchestration ✅ COMPLETED

## 📂 Source Data
- `suppliers.csv`
- `purchase_orders.csv`
- `deliveries.csv`
- `inventory.csv`

## 🗂️ Metadata Control Table

Control file path:
```text
medallion/control/ingestion_status.csv
```

Columns:
- `source_file_name`
- `source_container`
- `source_name`
- `ingestion_status` (Pending / Success / Failed)
- `ingestion_time`
- `error_message`

Exposed in Synapse Serverless SQL as:
```sql
dbo.ext_ingestion_control
```

## 🔄 ADF Pipelines

### Child Pipeline: `pl_copy_file_to_bronze`
Workflow:
```text
Lookup → Copy Data → Script (log status)
```
- Validates and ingests one source file
- Parameterized and reusable across all entities

### Master Pipeline: `pl_master_daily_ingestion`
Workflow:
1. Lookup pending files (`ingestion_status = 'Pending'`)
2. ForEach → Execute child pipeline
3. Append Variable stores processed files
4. If Condition runs Synapse notebook `Update_Control_Table` once

Result:
- Bronze ingestion completed to flat CSV format:
```text
bronze/<entity>.csv
```
(e.g., `bronze/suppliers.csv`)

---

# ✅ Epic 3 – Transformation (Bronze → Silver → Gold) ✅ COMPLETED

## Bronze → Silver (PySpark)

Notebook: `Transform_Bronze_To_Silver`  
Spark Pool: `sparkpool01`

Parameters:
- `entity_name`
- `processing_date` (`yyyy-MM-dd`)

Logic:
- Reads flat Bronze CSV (`bronze/<entity>.csv`)
- Applies entity-specific schemas
- Trims strings and casts data types
- Deduplicates by natural keys
- Writes partitioned Parquet to:
```text
silver/<entity>/year=YYYY/month=MM/day=DD/
```

Inventory behavior:
- Daily full snapshot overwrite for current day partition (dynamic overwrite)

Error behavior:
- Exceptions are re-raised to stop pipeline execution on failure

### Spark Performance Optimizations Applied
- DataFrame caching after CSV read
- Repartition by `year, month, day` before write
- Adaptive Query Execution (AQE) enabled

Benefits observed:
- Reduced redundant scans
- Mitigated small files issue
- Improved transformation speed and downstream read performance

## Silver Data Quality Gate

Notebook: `DQ_Silver` (supports single entity or `ALL`)

Checks:
- Row count > 0
- No null natural keys
- Key uniqueness

Logs written to:
```text
control/quality_gate_status.csv
```

Exposed in Synapse as:
```sql
dbo.ext_quality_gate_status
```

Behavior:
- Failing checks raise exceptions and stop orchestration

## ADF Silver Orchestration

### `pl_silver_entity`
- Executes transformation notebook (optional entity-level DQ)

### `pl_process_all_silver_entities`
- ForEach over:
  - `suppliers`
  - `purchase_orders`
  - `deliveries`
  - `inventory`
- Calls transformation pipeline for each entity

### `pl_master_silver_processing`
1. Lookup ingestion aggregate status from `dbo.ext_ingestion_control`
   - Returns `ALL_SUCCESS` / `SOME_FAILED`
2. If Condition:
   - True (`ALL_SUCCESS`):
     - Execute `pl_process_all_silver_entities`
     - Execute `DQ_Silver` (ALL)
     - Execute `Build Gold Layer` (Script)
   - False:
     - Fail activity with `BRONZE_INCOMPLETE`

### Pipeline Chaining
At the end of `pl_master_daily_ingestion`, an Execute Pipeline activity calls `pl_master_silver_processing` with:
```text
processing_date = utcNow()
```

## Gold Layer (Serverless SQL: CETAS + Views)

Script activity: `Build Gold Layer` (NonQuery)  
Parameterized by `processing_date`.

### Dimensions (as Views, latest partition only)
- `dim_supplier`
- `dim_product`
- `dim_warehouse`
- Surrogate keys generated using `ROW_NUMBER()`
- `dim_date` built as static external table (2024–2028)

### Facts (incremental daily Parquet partitions)
- `fact_orders/year=YYYY/month=MM/day=DD/`
- `fact_deliveries/year=YYYY/month=MM/day=DD/`

Process details:
- Temporary CETAS tables are dropped after write
- Persisted Parquet remains in storage
- Union views (`fact_orders`, `fact_deliveries`) use wildcard `OPENROWSET`
- Historical data is not rescanned (fully incremental accumulation)

---

# ✅ Epic 4 – Power BI Dashboards ✅ COMPLETED

## Semantic Model & Connectivity
- Connected Power BI Desktop to Synapse Serverless SQL endpoint (`gold_db`)
- Imported dimensions and used DirectQuery for facts
- Implemented star schema with single-direction 1:* relationships

## DAX Measures Implemented
- `Total Spend`
- `Total Orders`
- `On Time Delivery %`
- `OTIF %`

## Page 1 – Supply Chain Overview
- KPI cards
- Slicers (Year, Supplier, Warehouse)
- Clustered bar: Spend by Supplier
- Line chart: On-Time Delivery trend
- Donut chart: Order status breakdown
- Top 5 products by spend

## Page 2 – Supplier Detail (Drill-Through)
Drill target:
- `dim_supplier[supplier_name]`

Components:
- Supplier profile banner
- Monthly spend area chart
- Delivery health breakdown
- Itemized audit matrix

## Power BI Performance Optimization ✅ COMPLETED

### User-Defined Aggregations
Created Import-mode aggregation tables:
- `Fact Orders Agg`
- `Fact Deliveries Agg`

Pre-aggregated metrics include:
- TotalSpend
- OrderCount
- TotalDelivered
- Additional KPI-supporting aggregates

### Month-Level Date Surrogate Key
Calculated column:
```text
MonthDateSK = (year*10000) + (month*100) + 1
```
Mapped to:
- `dim_date[date_sk]` at month grain

### Aggregation Relationships
Linked aggregation tables to:
- `dim_supplier`
- `dim_product`
- `dim_warehouse`
- `dim_date` (via `MonthDateSK`)

### Aggregation Mappings
Configured mappings from DirectQuery facts:
- `order_date_sk` / `delivery_date_sk` → `MonthDateSK`
- Measure mappings with high precedence

Result:
- Executive and high-level visuals served from Import cache
- DirectQuery reserved for detailed drill-through

### DirectQuery Tuning
- Increased “Maximum connections per data source” to **10**

### Validation
- Performance Analyzer confirmed sub-second response for aggregated visuals without DirectQuery overhead on KPI views

---

# ✅ Epic 5 – Monitoring & Alerting ✅ COMPLETED

## Data Quality & Pipeline Health Visual Monitoring (Power BI) ✅

Data source:
```sql
dbo.ext_quality_gate_status
```

### DAX Measures

**LastRunStatus**
```dax
LastRunStatus = 
VAR MaxProcDate = MAX(ext_quality_gate_status[processing_date])
RETURN
IF(
    CALCULATE(
        COUNTROWS(ext_quality_gate_status),
        ext_quality_gate_status[processing_date] = MaxProcDate,
        ext_quality_gate_status[status] = "FAIL"
    ) > 0,
    "FAILURES FOUND",
    "ALL PASSED"
)
```

**TotalFailures**
```dax
TotalFailures = 
VAR MaxProcDate = MAX(ext_quality_gate_status[processing_date])
RETURN
CALCULATE(
    COUNTROWS(ext_quality_gate_status),
    ext_quality_gate_status[processing_date] = MaxProcDate,
    ext_quality_gate_status[status] = "FAIL"
)
```

**TotalPasses**
```dax
TotalPasses = 
VAR MaxProcDate = MAX(ext_quality_gate_status[processing_date])
RETURN
CALCULATE(
    COUNTROWS(ext_quality_gate_status),
    ext_quality_gate_status[processing_date] = MaxProcDate,
    ext_quality_gate_status[status] = "PASS"
)
```

### Page 3 Dashboard Components
- Executive status banner card with conditional formatting
  - `FAILURES FOUND` → soft red
  - `ALL PASSED` → soft green
- KPI cards: Total failures / total passes
- Trend chart: PASS vs FAIL by processing date
- Detailed quality audit table
- Date slicer for historical exploration

## ADF Failure Notifications ✅ IMPLEMENTED

Automated alerting for:
- `pl_master_daily_ingestion`
- `pl_master_silver_processing`

Implementation includes:
- Azure Monitor alert rules on failed pipeline runs
- Action Group configuration (email/webhook-ready)
- Operational notifications integrated into monitoring workflow

---

# 📈 Project Roadmap (Final Status)

| Epic | Status | Progress |
|------|:------:|:--------:|
| ✅ Epic 1 – Infrastructure & Security | Complete | 100% |
| ✅ Epic 2 – Data Ingestion & Orchestration | Complete | 100% |
| ✅ Epic 3 – Transformation (Silver & Gold) | Complete | 100% |
| ✅ Epic 4 – Analytics & Power BI | Complete | 100% |
| ✅ Epic 5 – Monitoring & Alerting | Complete | 100% |

---

# 🏗️ Medallion Architecture Summary

```text
                Source CSV Files
                       │
                       ▼
        ┌───────────────────────────┐
        │ Bronze Layer (Raw Data)   │
        └───────────────────────────┘
                       │
                       ▼
        ┌───────────────────────────┐
        │ Silver Layer (Clean Data) │
        └───────────────────────────┘
                       │
                       ▼
        ┌───────────────────────────┐
        │ Gold Layer (Business)     │
        └───────────────────────────┘
                       │
                       ▼
              Serverless SQL
                       │
                       ▼
                  Power BI
```

---

# 💰 Estimated Daily Cost

| Resource | Estimated Daily Cost |
|-----------|--------------------:|
| ADLS Gen2 | €0.01 |
| Azure Data Factory | Free (within student quota) |
| Serverless SQL | Negligible |
| Spark Pool | €0.68 (Auto Pause) |
| Azure Key Vault | €0.03 |
| **Estimated Total** | **< €1/day** |

---

# 📚 References

- Microsoft Learn – Azure Data Lake Storage Gen2
- Microsoft Learn – Azure Synapse Analytics
- Microsoft Learn – Azure Data Factory
- Microsoft Learn – Azure Key Vault
- Microsoft Learn – Azure RBAC
- Microsoft Learn – Azure Managed Identity
- Microsoft Learn – Serverless SQL Pools
- Microsoft Learn – Medallion Architecture
- Apache Spark Documentation
- Power BI Documentation

---

# 🏆 Key Technologies

| Category | Technologies |
|-----------|--------------|
| Cloud | Microsoft Azure |
| Storage | ADLS Gen2 |
| ETL | Azure Data Factory |
| Compute | Azure Synapse Spark |
| SQL | Synapse Serverless SQL Pool |
| Programming | PySpark |
| Security | Managed Identity, RBAC |
| Secrets | Azure Key Vault |
| BI | Power BI |

---

# ⭐ Acknowledgements

This project was developed as part of the **Big Data Engineering** curriculum and my **PFA internship at Smartovate** to demonstrate a complete enterprise-ready cloud data platform on Azure.

Special thanks to Microsoft Learn and the Azure ecosystem for the technical resources used throughout implementation.

---

# 📜 License

This project is distributed under the **MIT License**.

Feel free to use, modify, and extend it for educational or research purposes.

---

<div align="center">
  <b>Built with Azure • Synapse • Data Factory • Power BI</b>
</div>
