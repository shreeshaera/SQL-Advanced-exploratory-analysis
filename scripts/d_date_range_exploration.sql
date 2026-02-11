/*
============================================================================
                      EXPLORING THE DATE RANGE:
      Understanding historical data, order differences and age groups
============================================================================

SQL Functions Used:
- MIN
- MAX
- DATEDIFF
============================================================================
*/

--- Extracting the first, last order, and months range ---
SELECT 
    MIN(order_date) AS First_order,
    MAX(order_date) AS Last_order,
    DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS month_difference
FROM gold.fact_sales

--- Finding the total orders per year ---
SELECT
    YEAR(order_date) AS year,
    COUNT(*) total_orders
FROM gold.fact_sales
WHERE order_date is not null
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date) DESC

--- Finding the age groups ordering the products ---
SELECT 
    DATEDIFF(YEAR,birthdate,GETDATE()) AS age,
    COUNT(*) AS total_customers
FROM gold.dim_customers 
GROUP BY DATEDIFF(YEAR,birthdate,GETDATE()) 
ORDER BY total_customers DESC 
