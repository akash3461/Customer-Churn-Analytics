# Power BI Dashboard Guide

The `.pbix` file itself is built in Power BI Desktop. This folder holds everything needed to recreate it in about 30 minutes: the data, the DAX measures (`measures.dax`) and a colour theme (`theme.json`).

## 1. Load the data

1. Get Data > Text/CSV > `Data/Processed/customer_risk_scores.csv`
2. Check types: `churn_probability`, `monthly_charges`, `total_charges` as decimal; `tenure_months`, `cltv`, `churn_value`, `predicted_churn` as whole number; `latitude`, `longitude` as decimal with the data category set to Latitude / Longitude.
3. Optional: add `telco_churn_clean.csv` and relate it on `customer_id` (one to one) if you need the add-on service columns.
4. Sort `tenure_group` by a helper column (0-12 = 1, 13-24 = 2, 25-48 = 3, 49+ = 4) and `risk_band` as Low = 1, Medium = 2, High = 3.
5. View > Themes > Browse for themes > `theme.json`.
6. Paste the measures from `measures.dax` (Modeling > New measure).

## 2. Pages

### Page 1 - Executive Overview
- KPI cards: Total Customers, Churn Rate, MRR Lost, Annualised Revenue Lost, Avg Tenure
- Donut: churn split (`churn_label`)
- Clustered bar: Churn Rate by Contract
- Column chart: Churn Rate by Tenure Group
- Slicers: Contract, Internet Service, Senior Citizen

### Page 2 - Churn Drivers
- Bar: Churn Rate by Payment Method
- Bar: Churn Rate by Internet Service
- Matrix: Contract x Internet Service with Churn Rate and conditional-format colour scale
- Bar: Top 10 `churn_reason` (filter `churn_value` = 1, visual-level filter `churn_reason` is not "Not applicable")
- Scatter: Tenure vs Monthly Charges, colour by `churn_label`

### Page 3 - Risk and Action
- KPI cards: High Risk Active Customers, MRR At Risk, Avg Churn Probability
- Column chart: customers by `risk_band` (colours: green / amber / red)
- Table (top N = 25): customer_id, city, contract, monthly_charges, cltv, churn_probability - filtered to risk_band = High and churn_value = 0, sorted by churn_probability
- Map: bubble per city sized by MRR At Risk

## 3. Notes
- Keep slicers synced across pages 1 and 2 (View > Sync slicers).
- Add a tooltip page showing churn rate and customers for any hovered category.
- Probabilities in the file are cross-validated, so risk bands are a fair view of how the model ranks customers.
- Export screenshots to `images/` (`powerbi_overview.png`, etc.) to show them in the README.
