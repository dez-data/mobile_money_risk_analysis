WITH monthly AS (
  SELECT 
      DATE_TRUNC('month', timestamp)::DATE AS month,
      COUNT(*) AS total_transactions,
      SUM(is_fraud) AS fraud_count
  FROM transactions
  GROUP BY DATE_TRUNC('month', timestamp)
)
SELECT 
    month,
    total_transactions,
    fraud_count,
    ROUND(fraud_count * 100 / total_transactions,2) AS fraud_rate_percentage,
    SUM(fraud_count) OVER (ORDER BY month) AS cumulative_fraud
FROM monthly
ORDER BY month;
