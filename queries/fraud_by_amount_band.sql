WITH amount_bands AS (
    SELECT
        transaction_id,
        is_fraud,
        CASE
            WHEN amount < 500            THEN '1. Under 500'
            WHEN amount BETWEEN 500  AND 999   THEN '2. 500-999'
            WHEN amount BETWEEN 1000 AND 4999  THEN '3. 1000-4999'
            WHEN amount BETWEEN 5000 AND 19999 THEN '4. 5000-19999'
            ELSE                                    '5. 20000+'
        END AS amount_band
    FROM transactions
)
SELECT
    amount_band,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_count,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percentage,
    ROUND(100.0 - (SUM(is_fraud) * 100.0 / COUNT(*)) , 2) AS legit_rate_percentage
FROM amount_bands
GROUP BY amount_band
ORDER BY amount_band;
