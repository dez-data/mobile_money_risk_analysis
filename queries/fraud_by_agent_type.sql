SELECT
    a.agent_type,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(t.is_fraud) AS total_fraud_cases,
    ROUND(SUM(t.is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percentage,
    ROUND(SUM(t.amount * t.is_fraud) / 1000.0, 1) AS fraud_value_thousands
FROM transactions t
JOIN agents a ON t.agent_id = a.agent_id
GROUP BY a.agent_type
ORDER BY fraud_rate_pct DESC;
