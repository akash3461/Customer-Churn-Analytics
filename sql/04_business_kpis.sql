-- Revenue and value KPIs (SQLite syntax)

-- 1. Monthly recurring revenue lost to churn
SELECT ROUND(SUM(monthly_charges), 2) AS total_mrr,
       ROUND(SUM(CASE WHEN churn_value = 1 THEN monthly_charges ELSE 0 END), 2) AS mrr_lost,
       ROUND(100.0 * SUM(CASE WHEN churn_value = 1 THEN monthly_charges ELSE 0 END)
             / SUM(monthly_charges), 2) AS mrr_lost_pct
FROM customers;

-- 2. Average customer value: churned vs retained
SELECT churn_label,
       COUNT(*) AS customers,
       ROUND(AVG(monthly_charges), 2) AS avg_monthly_charges,
       ROUND(AVG(total_charges), 2) AS avg_total_charges,
       ROUND(AVG(tenure_months), 1) AS avg_tenure,
       ROUND(AVG(cltv), 0) AS avg_cltv
FROM customers
GROUP BY churn_label;

-- 3. Lifetime value lost by contract
SELECT contract,
       SUM(churn_value) AS churned,
       ROUND(SUM(CASE WHEN churn_value = 1 THEN cltv ELSE 0 END), 0) AS cltv_lost,
       ROUND(SUM(CASE WHEN churn_value = 1 THEN monthly_charges ELSE 0 END), 2) AS mrr_lost
FROM customers
GROUP BY contract
ORDER BY cltv_lost DESC;

-- 4. Share of churned customers that were month-to-month
SELECT ROUND(100.0 * SUM(CASE WHEN contract = 'Month-to-month' THEN 1 ELSE 0 END) / COUNT(*), 2)
       AS pct_of_churn_from_month_to_month
FROM customers
WHERE churn_value = 1;

-- 5. Monthly charge bands
SELECT CASE
           WHEN monthly_charges < 35 THEN 'Under 35'
           WHEN monthly_charges < 70 THEN '35-70'
           WHEN monthly_charges < 90 THEN '70-90'
           ELSE '90+'
       END AS charge_band,
       COUNT(*) AS customers,
       ROUND(100.0 * AVG(churn_value), 2) AS churn_rate_pct,
       ROUND(SUM(CASE WHEN churn_value = 1 THEN monthly_charges ELSE 0 END), 2) AS mrr_lost
FROM customers
GROUP BY 1
ORDER BY MIN(monthly_charges);

-- 6. Highest-risk active segment: month-to-month, fiber, electronic check, tenure <= 12
SELECT COUNT(*) AS customers,
       ROUND(100.0 * AVG(churn_value), 2) AS churn_rate_pct,
       ROUND(SUM(monthly_charges), 2) AS monthly_revenue
FROM customers
WHERE contract = 'Month-to-month'
  AND internet_service = 'Fiber optic'
  AND payment_method = 'Electronic check'
  AND tenure_months <= 12;

-- 7. Running churn by tenure month (window function)
SELECT tenure_months,
       COUNT(*) AS customers,
       SUM(churn_value) AS churned,
       SUM(SUM(churn_value)) OVER (ORDER BY tenure_months) AS cumulative_churned
FROM customers
GROUP BY tenure_months
ORDER BY tenure_months;
