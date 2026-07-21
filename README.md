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

This repository demonstrates the implementation of a complete cloud-native Modern Data Warehouse using Microsoft Azure services.

The project simulates a real enterprise Supply Chain Analytics platform by ingesting operational data exported from Oracle SCM Cloud into Azure Data Lake Storage Gen2.

Data is orchestrated using Azure Data Factory, transformed with Azure Synapse Analytics (Spark), queried using Serverless SQL, and finally exposed to Power BI for business intelligence reporting.

The project is divided into multiple Epics following an incremental software engineering methodology.

---

# 🎯 Project Objectives

- Build a complete Medallion Lakehouse architecture
- Automate data ingestion using Azure Data Factory
- Implement metadata-driven pipelines
- Secure resources using Managed Identities and RBAC
- Store secrets securely using Azure Key Vault
- Transform raw CSV files into analytics-ready Parquet datasets
- Design a dimensional Star Schema
- Deliver interactive Power BI dashboards

---

# ✨ Features

- ✅ Azure Data Lake Storage Gen2
- ✅ Azure Data Factory V2
- ✅ Azure Synapse Analytics
- ✅ Spark Notebooks (PySpark)
- ✅ Serverless SQL
- ✅ Azure Key Vault
- ✅ Managed Identity Authentication
- ✅ Azure RBAC
- ✅ Metadata-driven Pipelines
- ✅ Dynamic Parameters
- ✅ Enterprise Data Lake
- ✅ Medallion Architecture
- ✅ Power BI Integration

---

# 👨‍💻 Author

| | |
|:--:|:--|
| <img src="https://github.com/TageYassir.png" width="120"/> | **Yassir Tagemouati** <br><br> Big Data Engineering Student <br> Azure Data Engineering • Data Warehousing • Analytics <br><br> **GitHub:** https://github.com/TageYassir |

---

# 📚 Table of Contents

- Project Overview
- Solution Architecture
- Repository Structure
- Tech Stack
- Data Flow
- Epic 1 – Infrastructure & Security
- Epic 2 – Data Ingestion & Orchestration
- Roadmap
- References

---

# 🏛️ Solution Architecture

## Overall Azure Architecture

<p align="center">
<img src="images/AzureArch.drawio.png" width="100%">
</p>

<p align="center">
<b>Figure 1.</b> Enterprise Azure architecture implementing the Medallion Lakehouse.
</p>

---

## Data Ingestion Pipeline

<p align="center">
<img src="images/AzurePLFlow.drawio.png" width="100%">
</p>

<p align="center">
<b>Figure 2.</b> Azure Data Factory orchestration workflow.
</p>

---

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
Modern-Data-Warehouse/
│
├── data/
│
├── images/
│   ├── AzureArch.drawio.png
│   ├── AzurePLFlow.drawio.png
│   └── GoldShema.drawio.png
│
├── notebooks/
│
├── sql/
│
├── pipelines/
│
├── docs/
│
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
Gold Layer (Star Schema)
            │
            ▼
Serverless SQL
            │
            ▼
Power BI Dashboards
```

---

# ✅ EPIC 1 – Infrastructure & Security

## ☁️ Azure Resources

| Resource | Name | Region | Configuration |
|----------|------|--------|---------------|
| Azure Data Lake Storage Gen2 | `stlakesupply` | West Europe | Hierarchical Namespace, LRS, Cool Tier |
| Azure Data Factory | `adf-supplychain-1` | West Europe | Managed Identity |
| Azure Synapse Analytics | `syn-supplychain-1` | France Central | Spark + Serverless SQL |
| Azure Key Vault | `kv-supplychain-2026` | West Europe | Soft Delete Enabled |
| Spark Pool | `sparkpool01` | France Central | Spark 3.4, Auto Pause, Autoscale |

> **Note**
>
> Azure Synapse was deployed in France Central due to temporary capacity limitations in West Europe for Azure Student subscriptions.

---

## 🗂️ Medallion Storage Layout

```text
medallion/
│
├── bronze/
│   ├── suppliers/
│   ├── purchase_orders/
│   ├── deliveries/
│   └── inventory/
│
├── silver/
│   └── Parquet datasets
│
├── gold/
│   └── Star Schema
│
└── control/
    └── ingestion_status.csv
```

---

## 🔐 Security Implementation

| Resource | Role | Identity |
|----------|------|----------|
| ADLS Gen2 | Storage Blob Data Contributor | Azure Data Factory |
| ADLS Gen2 | Storage Blob Data Contributor | Azure Synapse |
| Synapse Workspace | Synapse Contributor | Azure Data Factory |
| SQL Database | db_owner | Azure Data Factory |

### Security Best Practices

- Managed Identities only
- No hardcoded credentials
- Azure RBAC
- Principle of Least Privilege
- Azure Key Vault integration
- Secret rotation ready

---

# ✅ EPIC 2 – Data Ingestion & Orchestration

Epic 2 focuses on building a **metadata-driven ingestion framework** capable of automatically detecting new source files, copying them into the Bronze layer, recording execution metadata, and preparing the data lake for downstream Spark transformations.

The solution is fully orchestrated using **Azure Data Factory** and **Azure Synapse Analytics**.

---

# 📂 Source Data

The project simulates data exported from **Oracle SCM Cloud**.

The following CSV datasets are used:

| Dataset | Description |
|----------|-------------|
| `suppliers.csv` | Supplier master data |
| `purchase_orders.csv` | Purchase order transactions |
| `deliveries.csv` | Delivery and shipment information |
| `inventory.csv` | Warehouse inventory status |

Each file is automatically ingested into the Bronze layer while preserving its original structure.

---

# 🗂️ Metadata Control Table

To avoid duplicate ingestion and monitor pipeline execution, a metadata control table is maintained.

**Location**

```text
medallion/control/ingestion_status.csv
```

## Columns

| Column | Description |
|----------|-------------|
| source_file_name | CSV file name |
| source_container | Source storage container |
| source_name | Dataset name |
| ingestion_status | Pending / Success / Failed |
| ingestion_time | Processing timestamp |
| error_message | Error details if execution fails |

The control table is exposed inside **Synapse Serverless SQL** through an external table.

```sql
dbo.ext_ingestion_control
```

This allows Azure Data Factory to query metadata directly using SQL.

---

# 🔄 Azure Data Factory Pipelines

Two reusable pipelines were developed.

---

## 1. Child Pipeline

### `pl_copy_file_to_bronze`

Responsible for processing one source file.

Workflow:

```text
Lookup
      │
      ▼
Validate File
      │
      ▼
Copy Activity
      │
      ▼
Bronze Layer
      │
      ▼
Update Control Table
```

### Activities

| Activity | Purpose |
|-----------|----------|
| Lookup | Validate source file |
| Copy Data | Copy CSV into Bronze |
| Script | Log execution status |

Destination path:

```text
bronze/{entity}/YYYY/MM/DD/
```

The pipeline is fully parameterized, allowing the same implementation to ingest any entity.

---

## 2. Master Pipeline

### `pl_master_daily_ingestion`

This pipeline orchestrates the entire ingestion process.

Workflow:

```text
Lookup Pending Files
          │
          ▼
ForEach
          │
          ▼
Execute Child Pipeline
          │
          ▼
Append Variable
          │
          ▼
If Condition
          │
          ▼
Run Spark Notebook
```

### Activities

| Activity | Description |
|-----------|-------------|
| Lookup | Retrieves Pending files |
| ForEach | Iterates through datasets |
| Execute Pipeline | Calls Child Pipeline |
| Append Variable | Stores processed files |
| If Condition | Launches Spark notebook |

---

# ⚙️ Dynamic Parameters

The pipelines use dynamic expressions to eliminate duplicated logic.

Examples include:

- Source file name
- Dataset name
- Destination folder
- Execution date
- Pipeline parameters
- Notebook parameters

This makes the ingestion framework reusable for any future dataset.

---

# 🧠 Synapse Spark Notebook

Notebook Name

```text
Update_Control_Table
```

Purpose:

- Receive processed file names from Azure Data Factory
- Load the metadata CSV
- Update status from **Pending** to **Success**
- Save the updated control table back to ADLS

Workflow

```text
ADF
 │
 │ File List
 ▼
Spark Notebook
 │
 ▼
Read Control CSV
 │
 ▼
Update Status
 │
 ▼
Write CSV
```

The notebook receives a comma-separated list of processed files using pipeline parameters.

---

# 📊 Current Architecture Status

```text
Source Files
      │
      ▼
Azure Data Lake
      │
      ▼
Azure Data Factory
      │
      ▼
Bronze Layer
      │
      ▼
Metadata Update
      │
      ▼
Spark Notebook
```

Epic 2 completes the ingestion layer of the Modern Data Warehouse.

---

# 💰 Estimated Daily Cost

Using Azure Student resources together with autoscaling and auto-pause significantly reduces operating costs.

| Resource | Estimated Daily Cost |
|-----------|--------------------:|
| ADLS Gen2 | €0.01 |
| Azure Data Factory | Free (within student quota) |
| Serverless SQL | Negligible |
| Spark Pool | €0 (Auto Pause) |
| Azure Key Vault | €0.03 |
| **Estimated Total** | **< €0.05/day** |

---

# 📈 Project Roadmap

| Epic | Status | Progress |
|------|:------:|:--------:|
| ✅ Epic 1 – Infrastructure & Security | Complete | 100% |
| ✅ Epic 2 – Data Ingestion & Orchestration | Complete | 100% |
| 🚧 Epic 3 – Data Transformation (Silver & Gold) | In Progress | 0% |
| ⏳ Epic 4 – Analytics & Power BI | Planned | 0% |

---

# 🎯 Epic 3 Preview

The next phase of the project will include:

- Bronze → Silver transformations
- Data cleansing
- Data validation
- Duplicate removal
- Type casting
- Parquet conversion
- Partition optimization
- Delta Lake implementation
- Star Schema modeling
- Fact and Dimension tables

---

# 📊 Epic 4 Preview

The final phase will focus on business intelligence.

Planned deliverables include:

- Executive Dashboard
- Procurement KPIs
- Supplier Performance
- Delivery Performance
- Inventory Analysis
- DirectQuery connectivity
- Interactive Power BI reports

---

# 🏗️ Medallion Architecture Overview

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
| SQL | Serverless SQL Pool |
| Programming | PySpark |
| Security | Managed Identity, RBAC |
| Secrets | Azure Key Vault |
| BI | Power BI |

---

# ⭐ Acknowledgements

This project was developed as part of the **Big Data Engineering** curriculum to demonstrate the implementation of an enterprise-grade cloud data platform using Microsoft Azure services and modern data engineering best practices.

Special thanks to Microsoft Learn documentation and the Azure ecosystem for providing the resources used throughout this project.

---

# 📜 License

This project is distributed under the **MIT License**.

Feel free to use, modify, and extend it for educational or research purposes.

---

<div align="center">

</div>
