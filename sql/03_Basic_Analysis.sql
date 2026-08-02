/*=========================================================
        PHASE 3 : BASIC BUSINESS ANALYSIS
=========================================================*/

----------------------------------------------------------
-- 1. Total Customers
----------------------------------------------------------
SELECT COUNT(*) AS total_customers
FROM customer_churn;


----------------------------------------------------------
-- 2. Total Churned Customers
----------------------------------------------------------
SELECT COUNT(*) AS churned_customers
FROM customer_churn
WHERE churn_label = 'Yes';


----------------------------------------------------------
-- 3. Total Active Customers
----------------------------------------------------------
SELECT COUNT(*) AS active_customers
FROM customer_churn
WHERE churn_label = 'No';


----------------------------------------------------------
-- 4. Overall Churn Rate (%)
----------------------------------------------------------
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn;


----------------------------------------------------------
-- 5. Customers by Gender
----------------------------------------------------------
SELECT
    gender,
    COUNT(*) AS total_customers
FROM customer_churn
GROUP BY gender
ORDER BY total_customers DESC;


----------------------------------------------------------
-- 6. Customers by Senior Citizen
----------------------------------------------------------
SELECT
    senior_citizen,
    COUNT(*) AS total_customers
FROM customer_churn
GROUP BY senior_citizen;


----------------------------------------------------------
-- 7. Customers by Contract Type
----------------------------------------------------------
SELECT
    contract,
    COUNT(*) AS total_customers
FROM customer_churn
GROUP BY contract
ORDER BY total_customers DESC;


----------------------------------------------------------
-- 8. Customers by Internet Service
----------------------------------------------------------
SELECT
    internet_service,
    COUNT(*) AS total_customers
FROM customer_churn
GROUP BY internet_service
ORDER BY total_customers DESC;


----------------------------------------------------------
-- 9. Customers by Payment Method
----------------------------------------------------------
SELECT
    payment_method,
    COUNT(*) AS total_customers
FROM customer_churn
GROUP BY payment_method
ORDER BY total_customers DESC;


----------------------------------------------------------
-- 10. Average Monthly Charges
----------------------------------------------------------
SELECT
    AVG(monthly_charges) AS average_monthly_charges
FROM customer_churn;


----------------------------------------------------------
-- 11. Average Tenure
----------------------------------------------------------
SELECT
    AVG(tenure_months) AS average_tenure
FROM customer_churn;


----------------------------------------------------------
-- 12. Maximum Monthly Charges
----------------------------------------------------------
SELECT
    MAX(monthly_charges) AS maximum_monthly_charges
FROM customer_churn;


----------------------------------------------------------
-- 13. Minimum Monthly Charges
----------------------------------------------------------
SELECT
    MIN(monthly_charges) AS minimum_monthly_charges
FROM customer_churn;


----------------------------------------------------------
-- 14. Churn by Contract
----------------------------------------------------------
SELECT
    contract,
    COUNT(*) AS churned_customers
FROM customer_churn
WHERE churn_label='Yes'
GROUP BY contract
ORDER BY churned_customers DESC;


----------------------------------------------------------
-- 15. Churn by Internet Service
----------------------------------------------------------
SELECT
    internet_service,
    COUNT(*) AS churned_customers
FROM customer_churn
WHERE churn_label='Yes'
GROUP BY internet_service
ORDER BY churned_customers DESC;


----------------------------------------------------------
-- 16. Churn by Payment Method
----------------------------------------------------------
SELECT
    payment_method,
    COUNT(*) AS churned_customers
FROM customer_churn
WHERE churn_label='Yes'
GROUP BY payment_method
ORDER BY churned_customers DESC;


----------------------------------------------------------
-- 17. Churn by Gender
----------------------------------------------------------
SELECT
    gender,
    COUNT(*) AS churned_customers
FROM customer_churn
WHERE churn_label='Yes'
GROUP BY gender;


----------------------------------------------------------
-- 18. Average CLTV
----------------------------------------------------------
SELECT
    AVG(cltv) AS average_cltv
FROM customer_churn;


----------------------------------------------------------
-- 19. Highest Churn Score
----------------------------------------------------------
SELECT TOP 10
    customerid,
    churn_score,
    churn_reason
FROM customer_churn
ORDER BY churn_score DESC;


----------------------------------------------------------
-- 20. Top 10 Highest Revenue Customers
----------------------------------------------------------
SELECT TOP 10
    customerid,
    monthly_charges,
    total_charges
FROM customer_churn
ORDER BY TRY_CAST(total_charges AS FLOAT) DESC;