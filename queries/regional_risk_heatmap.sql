WITH regional_stats AS(
    SELECT 
        c.region,
        COUNT(t.transaction_id) AS transaction_count,
        SUM(t.is_fraud) AS fraud_cases,
        ROUND(SUM(t.is_fraud)* 100 / COUNT(*), 2) AS fraud_rate_percentage,
        ROUND(AVG(t.amount), 0) AS avg_transaction_amount
   FROM transactions t 
   JOIN customers c ON t.customer_id = c.customer_id
   GROUP BY c.region 
)
SELECT 
    region,
    transaction_count,
    fraud_cases,
    fraud_rate_percentage,
    avg_transaction_amount,
    CASE 
        WHEN fraud_rate_percentage >= 3 AND transaction_count >= 2400 THEN 'HIGH PRIORITY'
        WHEN fraud_rate_percentage >= 2 OR transaction_count >= 2500 THEN 'MEDIUM PRIORITY'
        ELSE 'MONITOR'
    END AS risk_tier
FROM regional_stats
ORDER BY fraud_rate_percentage DESC;
