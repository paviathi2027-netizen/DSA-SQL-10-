SELECT 
user_id
FROM transactions
GROUP BY user_id 
having count(transaction_date) >=3
ORDER BY user_id ASC;

WITH daily_transaction AS (SELECT DISTINCT user_id,
Date(transaction_date) AS purchase_date
from transactions)
,
numbered_purchase AS (SELECT 
user_id,
purchase_date,
Lag(purchase_date, 1) OVER(PARTITION BY user_id
ORDER BY purchase_date) AS previous_date,
Lag(purchase_date,2) OVER(PARTITION BY user_id
ORDER BY purchase_date) as second_previous_date
FROM daily_transaction)

SELECT DISTINCT user_id
FROM numbered_purchase
WHERE DateDiff(purchase_day , previous_date) = 1 AND
DateDiff(previous_date, second_previous_date) = 1
ORDER BY user_id;
