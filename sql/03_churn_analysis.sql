-- Churn analysis queries (SQLite syntax)

-- 1. Overall churn rate
SELECT COUNT(*) AS customers,
       SUM(churn_value) AS churned,
       ROUND(100.0 * AVG(churn_value), 2) AS churn_rate_pct
FROM customers;

-- 2. Churn by contract type
SELECT contract,
       COUNT(*) AS customers,
       SUM(churn_value) AS churned,
       ROUND(100.0 * AVG(churn_value), 2) AS churn_rate_pct
FROM customers
GROUP BY contract
ORDER BY churn_rate_pct DESC;

-- 3. Churn by tenure group
SELECT tenure_group,
       COUNT(*) AS customers,
       SUM(churn_value) AS churned,
       ROUND(100.0 * AVG(churn_value), 2) AS churn_rate_pct
FROM customers
GROUP BY tenure_group
ORDER BY MIN(tenure_months);

-- 4. Churn by internet service
SELECT internet_service,
       COUNT(*) AS customers,
       ROUND(100.0 * AVG(churn_value), 2) AS churn_rate_pct,
       ROUND(AVG(monthly_charges), 2) AS avg_monthly_charges
FROM customers
GROUP BY internet_service
ORDER BY churn_rate_pct DESC;

-- 5. Churn by payment method
SELECT payment_method,
       COUNT(*) AS customers,
       ROUND(100.0 * AVG(churn_value), 2) AS churn_rate_pct
FROM customers
GROUP BY payment_method
ORDER BY churn_rate_pct DESC;

-- 6. Churn by demographics
SELECT 'Senior Citizen' AS segment, senior_citizen AS value, COUNT(*) AS customers,
       ROUND(100.0 * AVG(churn_value), 2) AS churn_rate_pct
FROM customers GROUP BY senior_citizen
UNION ALL
SELECT 'Partner', partner, COUNT(*), ROUND(100.0 * AVG(churn_value), 2)
FROM customers GROUP BY partner
UNION ALL
SELECT 'Dependents', dependents, COUNT(*), ROUND(100.0 * AVG(churn_value), 2)
FROM customers GROUP BY dependents
UNION ALL
SELECT 'Gender', gender, COUNT(*), ROUND(100.0 * AVG(churn_value), 2)
FROM customers GROUP BY gender;

-- 7. Add-on services and churn (internet customers only)
SELECT 'Online Security' AS service, online_security AS has_service,
       COUNT(*) AS customers, ROUND(100.0 * AVG(churn_value), 2) AS churn_rate_pct
FROM customers WHERE internet_service <> 'No' GROUP BY online_security
UNION ALL
SELECT 'Tech Support', tech_support, COUNT(*), ROUND(100.0 * AVG(churn_value), 2)
FROM customers WHERE internet_service <> 'No' GROUP BY tech_support
UNION ALL
SELECT 'Online Backup', online_backup, COUNT(*), ROUND(100.0 * AVG(churn_value), 2)
FROM customers WHERE internet_service <> 'No' GROUP BY online_backup
UNION ALL
SELECT 'Device Protection', device_protection, COUNT(*), ROUND(100.0 * AVG(churn_value), 2)
FROM customers WHERE internet_service <> 'No' GROUP BY device_protection;

-- 8. Contract x internet service
SELECT contract, internet_service,
       COUNT(*) AS customers,
       ROUND(100.0 * AVG(churn_value), 2) AS churn_rate_pct
FROM customers
GROUP BY contract, internet_service
ORDER BY churn_rate_pct DESC;

-- 9. Top churn reasons
SELECT churn_reason,
       COUNT(*) AS churned_customers,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_churn
FROM customers
WHERE churn_value = 1
GROUP BY churn_reason
ORDER BY churned_customers DESC
LIMIT 10;

-- 10. Cities with the highest churn (minimum 30 customers)
SELECT city,
       COUNT(*) AS customers,
       SUM(churn_value) AS churned,
       ROUND(100.0 * AVG(churn_value), 2) AS churn_rate_pct
FROM customers
GROUP BY city
HAVING COUNT(*) >= 30
ORDER BY churn_rate_pct DESC
LIMIT 10;
