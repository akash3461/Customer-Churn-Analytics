/*=========================================================
        PHASE 5 : ADVANCED SQL ANALYSIS
=========================================================*/

----------------------------------------------------------
-- 1. Rank Customers by Monthly Charges
----------------------------------------------------------

SELECT
    customerid,
    monthly_charges,
    RANK() OVER(ORDER BY monthly_charges DESC) AS charge_rank
FROM customer_churn;


----------------------------------------------------------
-- 2. Dense Rank by CLTV
----------------------------------------------------------

SELECT
    customerid,
    cltv,
    DENSE_RANK() OVER(ORDER BY cltv DESC) AS cltv_rank
FROM customer_churn;


----------------------------------------------------------
-- 3. Row Number by Tenure
----------------------------------------------------------

SELECT
    customerid,
    tenure_months,
    ROW_NUMBER() OVER(ORDER BY tenure_months DESC) AS row_num
FROM customer_churn;


----------------------------------------------------------
-- 4. Top 5 Customers in Each Contract Type
----------------------------------------------------------

WITH RankedCustomers AS
(
    SELECT
        customerid,
        contract,
        monthly_charges,
        ROW_NUMBER() OVER(
            PARTITION BY contract
            ORDER BY monthly_charges DESC
        ) AS rn
    FROM customer_churn
)
SELECT *
FROM RankedCustomers
WHERE rn <= 5;


----------------------------------------------------------
-- 5. Average Monthly Charges by Contract (Window Function)
----------------------------------------------------------

SELECT
    customerid,
    contract,
    monthly_charges,
    AVG(monthly_charges) OVER(PARTITION BY contract) AS avg_contract_charge
FROM customer_churn;


----------------------------------------------------------
-- 6. Running Total of Monthly Charges
----------------------------------------------------------

SELECT
    customerid,
    monthly_charges,
    SUM(monthly_charges) OVER(
        ORDER BY monthly_charges
    ) AS running_total
FROM customer_churn;


----------------------------------------------------------
-- 7. Previous Customer Monthly Charges (LAG)
----------------------------------------------------------

SELECT
    customerid,
    monthly_charges,
    LAG(monthly_charges) OVER(
        ORDER BY monthly_charges
    ) AS previous_charge
FROM customer_churn;


----------------------------------------------------------
-- 8. Next Customer Monthly Charges (LEAD)
----------------------------------------------------------

SELECT
    customerid,
    monthly_charges,
    LEAD(monthly_charges) OVER(
        ORDER BY monthly_charges
    ) AS next_charge
FROM customer_churn;


----------------------------------------------------------
-- 9. Divide Customers into 4 Revenue Groups
----------------------------------------------------------

SELECT
    customerid,
    monthly_charges,
    NTILE(4) OVER(
        ORDER BY monthly_charges DESC
    ) AS revenue_quartile
FROM customer_churn;


----------------------------------------------------------
-- 10. Top 10 Customers by CLTV
----------------------------------------------------------

SELECT TOP 10
    customerid,
    cltv,
    churn_label
FROM customer_churn
ORDER BY cltv DESC;


----------------------------------------------------------
-- 11. Highest Monthly Charges within Each Contract
----------------------------------------------------------

SELECT
    customerid,
    contract,
    monthly_charges
FROM
(
    SELECT
        customerid,
        contract,
        monthly_charges,
        ROW_NUMBER() OVER(
            PARTITION BY contract
            ORDER BY monthly_charges DESC
        ) AS rn
    FROM customer_churn
) t
WHERE rn = 1;


----------------------------------------------------------
-- 12. Churn Rate by Contract using Window Function
----------------------------------------------------------

SELECT
    contract,
    churn_label,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER(PARTITION BY contract),
        2
    ) AS percentage
FROM customer_churn
GROUP BY contract, churn_label;


----------------------------------------------------------
-- 13. Revenue Ranking
----------------------------------------------------------

SELECT
    customerid,
    TRY_CAST(total_charges AS FLOAT) AS total_revenue,
    RANK() OVER(
        ORDER BY TRY_CAST(total_charges AS FLOAT) DESC
    ) AS revenue_rank
FROM customer_churn;


----------------------------------------------------------
-- 14. Highest Churn Score by Contract
----------------------------------------------------------

SELECT
    contract,
    MAX(churn_score) AS highest_churn_score
FROM customer_churn
GROUP BY contract;


----------------------------------------------------------
-- 15. Customers Above Average CLTV
----------------------------------------------------------

SELECT
    customerid,
    cltv
FROM customer_churn
WHERE cltv >
(
    SELECT AVG(cltv)
    FROM customer_churn
)
ORDER BY cltv DESC;