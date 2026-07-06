WITH customer_fraud_summary AS (
  SELECT 
      t.customer_id,
      count(*) AS total_transactions,
      SUM(t.is_fraud) AS fraud_incidents,
      ROUND(SUM(t.amount) / 100) AS total_volume_hundreds
  FROM transactions t
  GROUP BY t.customer_id
  HAVING SUM(t.is_fraud) >= 2
)
SELECT
    c.region,
    c.registration_channel,
    CASE
        WHEN c.account_age_days < 90 THEN 'New (< 3 months)'
        WHEN c.account_age_days < 365 THEN 'Established (3-12 months)'
        ELSE 'Mature (more than one year)'
    END AS account_age_segment,
    COUNT(cf.customer_id) AS flagged_customers,
    SUM(cf.fraud_incidents) AS total_fraud_incidents,
    AVG(cf.total_transactions)::INT AS avg_transactions_per_flagged
FROM customer_fraud_summary cf 
JOIN customers c ON cf.customer_id = c.customer_id
GROUP BY c.region, c.registration_channel, account_age_segment
ORDER BY total_fraud_incidents desc
limit 20;
