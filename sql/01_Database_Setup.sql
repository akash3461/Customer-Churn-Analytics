CREATE DATABASE CustomerChurnDB;
GO

USE CustomerChurnDB;
GO

/*=========================================================
        PHASE 2 : DATA VALIDATION & CLEANING
=========================================================*/

----------------------------------------------------------
-- 1. View First 10 Records
----------------------------------------------------------
SELECT TOP 10 *
FROM customer_churn;


----------------------------------------------------------
-- 2. Count Total Records
----------------------------------------------------------
SELECT COUNT(*) AS total_customers
FROM customer_churn;


----------------------------------------------------------
-- 3. View Table Structure
----------------------------------------------------------
EXEC sp_help customer_churn;


----------------------------------------------------------
-- 4. View Column Names & Data Types
----------------------------------------------------------
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'customer_churn';


----------------------------------------------------------
-- 5. Check Duplicate Customer IDs
----------------------------------------------------------
SELECT
    customerid,
    COUNT(*) AS duplicate_count
FROM customer_churn
GROUP BY customerid
HAVING COUNT(*) > 1;


----------------------------------------------------------
-- 6. Count Duplicate Customers
----------------------------------------------------------
SELECT COUNT(*) AS duplicate_customers
FROM
(
    SELECT customerid
    FROM customer_churn
    GROUP BY customerid
    HAVING COUNT(*) > 1
) d;


----------------------------------------------------------
-- 7. Check Missing Customer IDs
----------------------------------------------------------
SELECT *
FROM customer_churn
WHERE customerid IS NULL
   OR customerid = '';


----------------------------------------------------------
-- 8. Check Missing Values
----------------------------------------------------------
SELECT

SUM(CASE WHEN customerid IS NULL OR customerid='' THEN 1 ELSE 0 END) AS customerid,

SUM(CASE WHEN gender IS NULL OR gender='' THEN 1 ELSE 0 END) AS gender,

SUM(CASE WHEN country IS NULL OR country='' THEN 1 ELSE 0 END) AS country,

SUM(CASE WHEN state IS NULL OR state='' THEN 1 ELSE 0 END) AS state,

SUM(CASE WHEN city IS NULL OR city='' THEN 1 ELSE 0 END) AS city,

SUM(CASE WHEN internet_service IS NULL OR internet_service='' THEN 1 ELSE 0 END) AS internet_service,

SUM(CASE WHEN payment_method IS NULL OR payment_method='' THEN 1 ELSE 0 END) AS payment_method,

SUM(CASE WHEN contract IS NULL OR contract='' THEN 1 ELSE 0 END) AS contract,

SUM(CASE WHEN monthly_charges IS NULL THEN 1 ELSE 0 END) AS monthly_charges,

SUM(CASE WHEN total_charges IS NULL OR total_charges='' THEN 1 ELSE 0 END) AS total_charges,

SUM(CASE WHEN churn_label IS NULL OR churn_label='' THEN 1 ELSE 0 END) AS churn_label,

SUM(CASE WHEN churn_reason IS NULL OR churn_reason='' THEN 1 ELSE 0 END) AS churn_reason

FROM customer_churn;


----------------------------------------------------------
-- 9. Verify Churn Distribution
----------------------------------------------------------
SELECT
    churn_label,
    COUNT(*) AS customers
FROM customer_churn
GROUP BY churn_label;


----------------------------------------------------------
-- 10. Verify Monthly Charges
----------------------------------------------------------
SELECT
    MIN(monthly_charges) AS minimum_monthly_charges,
    MAX(monthly_charges) AS maximum_monthly_charges,
    AVG(monthly_charges) AS average_monthly_charges
FROM customer_churn;


----------------------------------------------------------
-- 11. Verify Tenure
----------------------------------------------------------
SELECT
    MIN(tenure_months) AS minimum_tenure,
    MAX(tenure_months) AS maximum_tenure,
    AVG(tenure_months) AS average_tenure
FROM customer_churn;


----------------------------------------------------------
-- 12. Verify CLTV
----------------------------------------------------------
SELECT
    MIN(cltv) AS minimum_cltv,
    MAX(cltv) AS maximum_cltv,
    AVG(cltv) AS average_cltv
FROM customer_churn;


----------------------------------------------------------
-- 13. Verify Churn Score
----------------------------------------------------------
SELECT
    MIN(churn_score) AS minimum_score,
    MAX(churn_score) AS maximum_score,
    AVG(churn_score) AS average_score
FROM customer_churn;


----------------------------------------------------------
-- 14. Check Unique Gender Values
----------------------------------------------------------
SELECT DISTINCT gender
FROM customer_churn;


----------------------------------------------------------
-- 15. Check Unique Contract Types
----------------------------------------------------------
SELECT DISTINCT contract
FROM customer_churn;


----------------------------------------------------------
-- 16. Check Internet Services
----------------------------------------------------------
SELECT DISTINCT internet_service
FROM customer_churn;


----------------------------------------------------------
-- 17. Check Payment Methods
----------------------------------------------------------
SELECT DISTINCT payment_method
FROM customer_churn;


----------------------------------------------------------
-- 18. Check Churn Status
----------------------------------------------------------
SELECT DISTINCT churn_label
FROM customer_churn;


----------------------------------------------------------
-- 19. Check Invalid Total Charges
----------------------------------------------------------
SELECT *
FROM customer_churn
WHERE TRY_CAST(total_charges AS FLOAT) IS NULL
  AND total_charges IS NOT NULL
  AND total_charges <> '';


----------------------------------------------------------
-- 20. Final Dataset Validation
----------------------------------------------------------
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customerid) AS unique_customers
FROM customer_churn;