# VeriMatch: Intelligent Entity Reconciliation for Business Central

![Platform](https://img.shields.io/badge/Platform-Dynamics%20365%20Business%20Central-blue)
![Language](https://img.shields.io/badge/Language-AL-green)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

## 👋 What is this?

We've all been there: You need to import a legacy CSV or e-commerce data into Business Central, but the names don't *quite* match. "Contoso Ltd" in your file vs "Contoso Limited" in BC. Standard filters fail, and you're stuck manually fixing thousands of lines.

I built **VeriMatch** to solve this. It's an asynchronous engine that uses fuzzy logic (Levenshtein Distance) to find the best match for your data, giving you a similarity score so you can decide what to merge.

## 🚀 Why I built it (Key Features)

I wanted to create something strictly typed but dynamic enough to handle any table.

*   **Custom AL Levenshtein Algo:** I wrote the math from scratch in AL. It uses a matrix-based approach to calculate exactly how "close" two strings are.
*   **Completely Dynamic:** I used `RecordRef` and `FieldRef` for everything. You can match Customers, Items, Vendors, or custom tables without changing a single line of code.
*   **Performance First:** Heavy math in AL can be slow, so I offloaded the processing to the **Job Queue**. It runs in the background so the UI doesn't freeze.
*   **Memory Optimization:** I added logic to skip expensive calculations if string lengths are wildly different, and I manually handle memory clearing on the matrix arrays to keep the service tier happy.
*   **Transactional Updates:** You approve the matches in a worksheet, and the updates are applied in a single batch.

## 🛠 Under the Hood

I architected this using the **Handler Pattern** to keep my logic clean:

1.  **`VRM Algorithm Lib`:** A stateless Codeunit. It just takes two strings and returns a % score. Pure math, no database dependencies.
2.  **`VRM Processor`:** The heavy lifter. It handles the Job Queue execution, loops through the data, and manages the `RecordRef` logic.
3.  **`VRM Import Buffer`:** A flattened table to get data in fast (SQL optimized) before we process it.

## 📦 Installation

1.  Clone this repo.
2.  Open in VS Code.
3.  Download symbols (`Ctrl+Shift+P` -> `AL: Download Symbols`).
4.  Hit `F5` to publish to your Sandbox/Docker.

## 📖 How to use it

### 1. Setup a Project
Search for **"VeriMatch Projects"**. This is where you define the rules.
*   **Target Table:** Pick where you want data to go (e.g., `18` for Customer).
*   **Match Field:** Pick the field we compare names against (e.g., `2` Name).
*   **Threshold:** I usually set this to `80`. Anything lower is usually noise.
*   **Delimiter:** Set this to whatever your CSV uses (Semicolon, Comma, etc.).

### 2. Import Data
Grab your messy CSV file (no headers needed).
```csv
1001;Adatum Corp;555-0100
1002;Contoso Ltd.;555-0199
```

Click **"Import CSV"**. The app will import the data based on your Key Column and Delimiter settings.

### 3. Map Fields
Tell the system where the data goes. In the **Update Mapping** subform:
*   *Example:* Take CSV Col `3` -> Put it in BC Field `9` (Phone No.).

### 4. Run Analysis
Click **"Run Analysis"**. Go grab a coffee ☕. The Job Queue does the work.

### 5. Review Candidates
When it's done, open the **Candidates Worksheet**.
1.  Sort by **Score**.
2.  You'll see matches like "Contoso Ltd" = "Contoso Limited" (95%).
3.  Select the ones you like (Ctrl+Click).
4.  Hit **"Set Selected to Update"**.
5.  Click **"Execute Updates"** to commit the changes.

---

## 🔌 API Integration (Headless Mode)

I also exposed the whole engine via **Connect APIs**. This is great if you want to push data from a Python script or an external PIM without touching the UI.

**Base URL:** `https://api.businesscentral.dynamics.com/v2.0/{tenant}/sandbox/api/contoso/verimatch/v1.0/companies({id})`

### 1. Create a Project
**POST** `/projects`
```json
{
    "code": "API-JOB-01",
    "description": "Nightly Customer Sync",
    "targetTableId": 18,
    "targetFieldId": 2,
    "minConfidence": 85,
    "csvKeyColumnNo": 1
}
```

### 2. Configure Mapping
**POST** `/fieldMaps`
```json
{
    "projectCode": "API-JOB-01",
    "sourceColumnIndex": 3,
    "destTableId": 18,
    "destFieldId": 9
}
```

### 3. Push Data (Buffer)
**POST** `/bufferLines`

```json
{
    "projectCode": "API-JOB-01",
    "lineNo": 1,
    "searchKey": "Contoso Ltd",
    "col1": "Contoso Ltd",
    "col2": "555-0100"
}
```

### 4. Run Analysis (Bound Action)
**POST** `/projects({systemId})/Microsoft.NAV.runAnalysis`

### 5. Review & Approve
**GET** `/candidates?$filter=matchScore ge 90`

**PATCH** `/candidates({systemId})`
```json
{
    "userDecision": "Update Record"
}
```

## 🛡 License

This project is licensed under the MIT License - see the LICENSE file for details.
