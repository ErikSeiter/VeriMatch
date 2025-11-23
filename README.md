# VeriMatch: Intelligent Entity Reconciliation for Business Central

![Platform](https://img.shields.io/badge/Platform-Dynamics%20365%20Business%20Central-blue)
![Language](https://img.shields.io/badge/Language-AL-green)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

**VeriMatch** is an asynchronous, fuzzy-logic reconciliation engine designed for Microsoft Dynamics 365 Business Central. It solves the common problem of reconciling external datasets (legacy CSV imports, e-commerce lists) against internal master data where direct ID matching is impossible.

By implementing a normalized **Levenshtein Distance algorithm**, VeriMatch calculates similarity scores between strings, allowing users to identify and merge records (e.g., matching *"Contoso Ltd"* with *"Contoso Limited"*).

## 🚀 Key Features

*   **Fuzzy Matching Algorithm:** Custom AL implementation of Levenshtein Distance with matrix memory optimization.
*   **Dynamic Architecture:** Built on `RecordRef` and `FieldRef`, allowing reconciliation against **any** Business Central table (Customers, Vendors, Items, Contacts) without code changes.
*   **Asynchronous Processing:** Heavy matching logic is offloaded to the **Job Queue** to prevent UI blocking during large dataset analysis.
*   **Configurable Mapping:** User-defined mapping between CSV columns and Target Table fields.
*   **Batch Execution:** "Update Record" decisions are applied transactionally in bulk.
*   **Flexible Import:** Supports multiple CSV delimiters (Semicolon, Comma, Pipe, Tab, etc.) via extensible Enums.

## 🛠 Architecture

The solution is architected using the **Handler Pattern** to separate UI, Logic, and Data layers:

1.  **`VRM Algorithm Lib` (Codeunit):** A stateless library responsible solely for mathematical string comparison.
2.  **`VRM Processor` (Codeunit):** Handles the orchestration of the Job Queue, data iteration, and `RecordRef` operations.
3.  **`VRM Import Buffer` (Table):** A flattened, high-performance staging table used to minimize SQL overhead during the initial import.

### Performance Optimizations
*   **Length Heuristics:** The processor skips expensive matrix calculations if string length deltas exceed a specific threshold.
*   **Memory Management:** Explicit clearing of large array variables (`Clear(Matrix)`) between iterations to prevent dirty reads in the AL service.

## 📦 Installation

1.  Clone this repository.
2.  Open the folder in VS Code.
3.  Download symbols using `AL: Download Symbols`.
4.  Publish to your Docker container or SaaS Sandbox (`F5`).

## 📖 Usage Guide

### 1. Setup a Project
Search for **"VeriMatch Projects"** and create a new entry:
*   **Target Table:** `18` (Customer)
*   **Match Field:** `2` (Name)
*   **Threshold:** `80` (Min. confidence percentage)
*   **Delimiter:** Select your CSV format (e.g., Semicolon).

### 2. Import Data
Prepare a CSV file (no headers required).
```csv
1001;Adatum Corp;555-0100
1002;Contoso Ltd.;555-0199
```

Click **"Import CSV"** on the Project Card. Note which column contains the Name (Search Key).

### 3. Map Fields
Define which CSV columns should update which Business Central fields in the **Update Mapping** subform.
*   *Example:* CSV Col `3` -> Update BC Field `9` (Phone No.).

### 4. Execute Analysis
Click **"Run Analysis"**. This submits a background job. Once the status is `Analysis_Complete`, click **"Review Candidates"**.

### 5. Review and Apply
1.  Open the **Candidates Worksheet**.
2.  Review matches sorted by Score.
3.  Select valid matches (Ctrl+Click) and use **"Set Selected to Update"**.
4.  Click **"Execute Updates"** to commit changes to the database.

## 🛡 License

This project is licensed under the MIT License - see the LICENSE file for details.
