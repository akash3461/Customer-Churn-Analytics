-- Cleaned analysis table built from customers_raw.
-- total_charges arrives as text; 11 new customers (tenure = 0) have a blank value.
DROP TABLE IF EXISTS customers;

CREATE TABLE customers AS
SELECT
    customer_id,
    city,
    zip_code,
    latitude,
    longitude,
    gender,
    senior_citizen,
    partner,
    dependents,
    tenure_months,
    phone_service,
    multiple_lines,
    internet_service,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies,
    contract,
    paperless_billing,
    payment_method,
    monthly_charges,
    CASE
        WHEN TRIM(total_charges) = '' THEN 0.0
        ELSE CAST(total_charges AS REAL)
    END AS total_charges,
    churn_value,
    churn_label,
    churn_score,
    cltv,
    churn_reason,
    CASE
        WHEN tenure_months <= 12 THEN '0-12 months'
        WHEN tenure_months <= 24 THEN '13-24 months'
        WHEN tenure_months <= 48 THEN '25-48 months'
        ELSE '49+ months'
    END AS tenure_group
FROM customers_raw;

-- sanity checks
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT customer_id) AS unique_customers,
       SUM(CASE WHEN total_charges = 0 THEN 1 ELSE 0 END) AS zero_total_charges
FROM customers;
