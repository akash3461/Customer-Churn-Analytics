/*=========================================================
        PHASE 4 : INTERMEDIATE SQL ANALYSIS
=========================================================*/

----------------------------------------------------------
-- 1. Churn Rate by Contract Type
----------------------------------------------------------
SELECT
    contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn
GROUP BY contract
ORDER BY churn_rate DESC;


----------------------------------------------------------
-- 2. Churn Rate by Internet Service
----------------------------------------------------------
SELECT
    internet_service,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn
GROUP BY internet_service
ORDER BY churn_rate DESC;


----------------------------------------------------------
-- 3. Churn Rate by Payment Method
----------------------------------------------------------
SELECT
    payment_method,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn
GROUP BY payment_method
ORDER BY churn_rate DESC;


----------------------------------------------------------
-- 4. Monthly Charge Category using CASE
----------------------------------------------------------
SELECT
    customerid,
    monthly_charges,
    CASE
        WHEN monthly_charges < 30 THEN 'Low'
        WHEN monthly_charges BETWEEN 30 AND 70 THEN 'Medium'
        ELSE 'High'
    END AS charge_category
FROM customer_churn;


----------------------------------------------------------
-- 5. Customer Segment using CASE
----------------------------------------------------------
SELECT
    customerid,
    tenure_months,
    CASE
        WHEN tenure_months < 12 THEN 'New Customer'
        WHEN tenure_months BETWEEN 12 AND 48 THEN 'Regular Customer'
        ELSE 'Loyal Customer'
    END AS customer_segment
FROM customer_churn;


----------------------------------------------------------
-- 6. Contracts Having More Than 1000 Customers
----------------------------------------------------------
SELECT
    contract,
    COUNT(*) AS total_customers
FROM customer_churn
GROUP BY contract
HAVING COUNT(*) > 1000;


----------------------------------------------------------
-- 7. Average Monthly Charges by Contract
----------------------------------------------------------
SELECT
    contract,
    AVG(monthly_charges) AS average_monthly_charge
FROM customer_churn
GROUP BY contract
ORDER BY average_monthly_charge DESC;


----------------------------------------------------------
-- 8. Average CLTV by Contract
----------------------------------------------------------
SELECT
    contract,
    AVG(cltv) AS average_cltv
FROM customer_churn
GROUP BY contract
ORDER BY average_cltv DESC;


----------------------------------------------------------
-- 9. Customers Paying Above Average Monthly Charges
----------------------------------------------------------
SELECT
    customerid,
    monthly_charges
FROM customer_churn
WHERE monthly_charges >
(
    SELECT AVG(monthly_charges)
    FROM customer_churn
)
ORDER BY monthly_charges DESC;


----------------------------------------------------------
-- 10. Customers Having Highest CLTV
----------------------------------------------------------
SELECT TOP 20
    customerid,
    cltv
FROM customer_churn
ORDER BY cltv DESC;


----------------------------------------------------------
-- 11. Churned Customers with High Monthly Charges
----------------------------------------------------------
SELECT
    customerid,
    monthly_charges,
    churn_label
FROM customer_churn
WHERE churn_label='Yes'
AND monthly_charges > 80
ORDER BY monthly_charges DESC;


----------------------------------------------------------
-- 12. CTE Example - High Value Customers
----------------------------------------------------------
WITH HighValueCustomers AS
(
    SELECT
        customerid,
        cltv,
        monthly_charges
    FROM customer_churn
    WHERE cltv >
    (
        SELECT AVG(cltv)
        FROM customer_churn
    )
)
SELECT *
FROM HighValueCustomers
ORDER BY cltv DESC;


----------------------------------------------------------
-- 13. Partner vs Churn
----------------------------------------------------------
SELECT
    partner,
    churn_label,
    COUNT(*) AS customers
FROM customer_churn
GROUP BY partner, churn_label
ORDER BY partner;


----------------------------------------------------------
-- 14. Dependents vs Churn
----------------------------------------------------------
SELECT
    dependents,
    churn_label,
    COUNT(*) AS customers
FROM customer_churn
GROUP BY dependents, churn_label
ORDER BY dependents;


----------------------------------------------------------
-- 15. Senior Citizens vs Churn
----------------------------------------------------------
SELECT
    senior_citizen,
    churn_label,
    COUNT(*) AS customers
FROM customer_churn
GROUP BY senior_citizen, churn_label
ORDER BY senior_citizen;