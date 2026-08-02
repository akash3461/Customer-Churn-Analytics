/*=========================================================
        PHASE 6 : SQL VIEWS
=========================================================*/

----------------------------------------------------------
-- 1. Churn Summary View
----------------------------------------------------------

CREATE VIEW vw_ChurnSummary AS
SELECT
    churn_label,
    COUNT(*) AS total_customers,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM customer_churn),
        2
    ) AS percentage
FROM customer_churn
GROUP BY churn_label;
GO


----------------------------------------------------------
-- 2. High Value Customers
----------------------------------------------------------

CREATE VIEW vw_HighValueCustomers AS
SELECT
    customerid,
    cltv,
    monthly_charges,
    contract,
    churn_label
FROM customer_churn
WHERE cltv >
(
    SELECT AVG(cltv)
    FROM customer_churn
);
GO


----------------------------------------------------------
-- 3. Revenue Summary
----------------------------------------------------------

CREATE VIEW vw_RevenueSummary AS
SELECT
    customerid,
    TRY_CAST(total_charges AS FLOAT) AS total_revenue,
    monthly_charges,
    tenure_months
FROM customer_churn;
GO


----------------------------------------------------------
-- 4. Contract Analysis
----------------------------------------------------------

CREATE VIEW vw_ContractAnalysis AS
SELECT
    contract,
    COUNT(*) AS customers,
    AVG(monthly_charges) AS avg_monthly_charge,
    AVG(cltv) AS avg_cltv
FROM customer_churn
GROUP BY contract;
GO


----------------------------------------------------------
-- 5. Payment Method Analysis
----------------------------------------------------------

CREATE VIEW vw_PaymentAnalysis AS
SELECT
    payment_method,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END) AS churned_customers
FROM customer_churn
GROUP BY payment_method;
GO