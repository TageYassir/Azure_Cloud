# Modern Data Warehouse – Supply Chain & Logistics Analytics

[![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com/)
[![Synapse](https://img.shields.io/badge/Azure_Synapse-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com/en-us/services/synapse-analytics/)
[![ADF](https://img.shields.io/badge/Azure_Data_Factory-FF6F00?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com/en-us/services/data-factory/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**End-to-end Modern Data Warehouse implementation on Azure for Supply Chain & Logistics Analytics.**

This project follows the **Medallion Architecture (Bronze → Silver → Gold)** , orchestrated by Azure Data Factory, processed by Azure Synapse (Spark & Serverless SQL), and served via Power BI. This repository covers **Epic 1 (Infrastructure & Security)** and **Epic 2 (Data Ingestion & Orchestration)** .

---

## 🤝 Contributors

| Avatar | Contributor |
| :---: | :--- |
| <img src="https://github.com/TageYassir.png" width="40px;"/> | **Yassir Tagemouati** [@TageYassir](https://github.com/TageYassir) |

---

## 📋 Table of Contents
- [Project Overview](#-project-overview)
- [Solution Architecture](#-solution-architecture)
- [Tech Stack](#-tech-stack)
- [Epic 1 – Infrastructure & Security](#-epic-1--infrastructure--security-completed)
- [Epic 2 – Data Ingestion & Orchestration](#-epic-2--data-ingestion--orchestration-completed)
- [Project Status](#-project-status)

---

## 📖 Project Overview

As a 2nd-year Big Data Engineering student, I built this platform to simulate a real-world enterprise data warehouse. The solution ingests simulated Oracle SCM Cloud CSV files (`suppliers`, `purchase_orders`, `deliveries`, `inventory`), processes them through a structured lakehouse, and exposes business KPIs for reporting.

### Key Objectives
- ✅ Implement the **Medallion Architecture** on Azure.
- ✅ Enforce **Principle of Least Privilege** using Managed Identities & RBAC.
- ✅ Build **parameterized, reusable data pipelines** in ADF.
- ✅ Perform **data cleansing, deduplication, and type casting** using PySpark (planned for Epic 3).
- ✅ Model a **Star Schema** for Supply Chain Analytics (planned for Epic 3).
- ✅ Create interactive **Power BI dashboards** with DirectQuery (planned for Epic 4).

---

## 🏛️ Solution Architecture

<p align="center">
  <img src="images/AzureArch.drawio.png" alt="Azure Solution Architecture" width="100%">
</p>
<p align="center"><b>Figure 1.</b> Overall Azure architecture implementing the Medallion Data Lake.</p>

<p align="center">
  <img src="images/AzurePLFlow.drawio.png" alt="Azure Data Pipeline Flow" width="100%">
</p>
<p align="center"><b>Figure 2.</b> End-to-end data ingestion and orchestration workflow.</p>

<p align="center">
  <img src="images/GoldShema.drawio.png" alt="Gold Layer Star Schema" width="100%">
</p>
<p align="center"><b>Figure 3.</b> Business-oriented dimensional model (Star Schema) for Power BI reporting.</p>

---

## 🛠️ Tech Stack

| Layer | Technology |
| :--- | :--- |
| **Storage** | Azure Data Lake Storage Gen2 (ADLS Gen2) |
| **Orchestration** | Azure Data Factory (ADF) V2 |
| **Processing (Batch)** | Azure Synapse Analytics – Spark Pool (PySpark) |
| **Processing (Query)** | Azure Synapse – Serverless SQL Pool |
| **Metadata/Secrets** | Azure Key Vault |
| **Serving/Reporting** | Power BI (DirectQuery) |
| **Security** | Managed Identities, RBAC, SQL `db_owner` |

---

# ✅ EPIC 1 – Infrastructure & Security *(COMPLETED)*

## ☁️ Azure Resources Deployed

| Resource | Name | Region | Configuration |
|----------|------|--------|---------------|
| Azure Data Lake Storage Gen2 | `stlakesupply` | West Europe | Hierarchical Namespace enabled, Cool Tier, LRS |
| Azure Data Factory V2 | `adf-supplychain-1` | West Europe | System-Assigned Managed Identity |
| Azure Synapse Analytics | `syn-supplychain-1` | France Central* | Serverless SQL + Spark |
| Azure Key Vault | `kv-supplychain-2026` | West Europe | Standard Tier, Soft Delete enabled |
| Spark Pool | `sparkpool01` | France Central* | Small (4 vCPUs, 32 GB RAM), Autoscale (3–10 nodes), Auto Pause (5 mins), Spark 3.4 |

> **Note:** Synapse was deployed in **France Central** due to temporary capacity limitations in West Europe for Student subscriptions.

## 🗂️ Medallion Storage Layout (`stlakesupply` / `medallion` container)

medallion/
├── bronze/          # Raw CSV (immutable, date-partitioned)
│   ├── suppliers/YYYY/MM/DD/
│   ├── purchase_orders/YYYY/MM/DD/
│   └── ...
├── silver/          # Cleaned Parquet (to be implemented in Epic 3)
│   └── ...
├── gold/            # Star Schema (to be implemented in Epic 3)
│   └── ...
└── control/         # Metadata & logging
    └── ingestion_status.csv


## 🔐 Security & RBAC

| Resource | Role | Identity |
|----------|------|----------|
| ADLS Gen2 (`stlakesupply`) | Storage Blob Data Contributor | ADF & Synapse Managed Identities |
| Synapse Workspace | Synapse Contributor | ADF Managed Identity |
| Serverless SQL DB (`supplychain_db`) | `db_owner` | ADF Managed Identity |

- **Azure Key Vault** stores `synapse-sql-admin-password`.  
- **Principle of Least Privilege** strictly enforced (no hardcoded credentials, Managed Identities only).

---

# ✅ EPIC 2 – Data Ingestion & Orchestration *(COMPLETED)*

## 📂 Control Table (Metadata)
- **Location**: `medallion/control/ingestion_status.csv`
- **Columns**: `source_file_name`, `source_container`, `source_name`, `ingestion_status`, `ingestion_time`, `error_message`
- **External Table** in Synapse Serverless SQL: `dbo.ext_ingestion_control` (points to the CSV via `OPENROWSET`).

## 🔄 ADF Pipelines
| Pipeline | Description |
| :--- | :--- |
| **`pl_copy_file_to_bronze`** (Child) | 1. `Lookup` (validates file existence). <br> 2. `Copy Data` (moves CSV from `source-files` to `bronze/{entity}/YYYY/MM/DD/`). <br> 3. `Script` (logs status to control table). |
| **`pl_master_daily_ingestion`** (Master) | 1. `Lookup` (`Get Pending Files` – filters `ingestion_status = 'Pending'`). <br> 2. `ForEach` (iterates and executes the child pipeline). <br> 3. `Append Variable` (collects successfully processed file names). <br> 4. `If Condition` (if files were processed, runs Synapse Spark notebook). |

## 🧠 Synapse Notebook: `Update_Control_Table`
- **Purpose**: Batch-update the control CSV status from `Pending` to `Success` for all processed files.
- **Integration**: Triggered by the master ADF pipeline. It accepts a comma-separated file list (via ADF dynamic content) and updates the CSV in ADLS.
- **Status**: Parameterization is fully functional (single cell, no auto-generated conflicts).

---

## 💰 Estimated Daily Cost (Student Tier)

| Resource | Cost |
|----------|------|
| ADLS Gen2 | ~€0.01/day |
| Azure Data Factory | €0 (First 1M activities free) |
| Synapse Serverless SQL | €0 (Minimal queries) |
| Spark Pool | €0 (Auto Pause enabled) |
| Azure Key Vault | ~€0.03/day |
| **Total** | **< €0.05/day** |

---

## 📌 Project Status

| Epic | Status | Completion |
| :--- | :---: | :--- |
| **Epic 1 – Infrastructure & Security** | ✅ Done | 100% |
| **Epic 2 – Data Ingestion & Orchestration** | ✅ Done | 100% |

---

## 📚 References & Best Practices Applied

- [Medallion Architecture in Azure Synapse](https://learn.microsoft.com/en-us/azure/synapse-analytics/cicd/medallion-architecture)
- [Azure RBAC for Data Lake](https://learn.microsoft.com/en-us/azure/role-based-access-control/)
- [ADF Parameterized Pipelines](https://learn.microsoft.com/en-us/azure/data-factory/parameters-data-flow)
