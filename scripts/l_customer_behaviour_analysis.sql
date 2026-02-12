/*
==================================================================================================
                            CUSTOMER BEHAVIOUR ANALYSIS
--------------------------------------------------------------------------------------------------
                To understand the customers frequently bought items and products
                      and using it to change the business production
==================================================================================================

SQL functions used:
    - LAG
    - ABS
    - CTE
    - DATEDIFF
    - JOINS 
==================================================================================================
*/

--- items brought together by customers ---
SELECT 
    p1.product_name AS product_one, 
    p2.product_name AS product_two,
    COUNT(*) items_bought_together
FROM gold.fact_sales s

    LEFT JOIN gold.fact_sales s2
    ON s.order_number = s2.order_number
        AND s.product_key < s2.product_key 

    JOIN gold.dim_products p1
    ON p1.product_key = s.product_key

    JOIN gold.dim_products p2
    ON p2.product_key = s2.product_key

GROUP BY p1.product_name, p2.product_name
ORDER BY items_bought_together DESC;

--- Avg gap between buying the same product again by the same customer ---
WITH previous_date AS
(
SELECT 
    s.customer_key, 
    s.order_date,
    p.product_name,
    LAG(s.order_date) OVER(PARTITION BY s.customer_key, s.product_key ORDER BY s.order_date)  AS previous_date
FROM gold.fact_sales s
    JOIN gold.dim_products p
    ON s.product_key = p.product_key
),
average_gap AS
(
SELECT
    customer_key, 
    product_name,
    ABS(AVG(DATEDIFF(DAY,order_date,previous_date))) AS average_gap
FROM previous_date
WHERE previous_date IS NOT NULL
GROUP BY customer_key, product_name

)

SELECT customer_key,product_name,average_gap,
CASE
  WHEN months < 1.5
    THEN CONCAT(ROUND(months,1), ' month')
  WHEN months < 12
    THEN CONCAT(ROUND(months,1), ' months')
  WHEN ROUND(years,1) = 1
    THEN CONCAT(ROUND(years,1), ' year')
  ELSE
    CONCAT(ROUND(years,1), ' years')
END AS Time_difference
FROM (
  SELECT *,
         CAST(average_gap AS FLOAT)/30 AS months,
         cast(average_gap as float)/365 as years
  FROM average_gap
) t
ORDER BY average_gap
