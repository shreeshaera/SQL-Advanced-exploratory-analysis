/*
===============================================================================
                        CUMULATIVE ANALYSIS
-------------------------------------------------------------------------------
     To calculate running totals or moving averages for key metrics and
            To track performance over time cumulatively.
===============================================================================

SQL Functions Used:
    - SUM
    - AVG
    - OVER
===============================================================================
*/

---- Retrieving total years sales and cumilative growth over time ----
SELECT *,
	SUM(total_sales) OVER( ORDER BY order_Date) AS running_total,
	AVG(average_price) OVER(ORDER BY order_Date) AS running_average
FROM
(
SELECT 
    DATETRUNC(YEAR,order_date) AS order_Date,
    SUM(sales_amount) AS total_sales,
    AVG(sales_amount) AS average_price
FROM gold.fact_sales
WHERE  DATETRUNC(YEAR,order_date)  IS NOT NULL
GROUP BY DATETRUNC(YEAR,order_date) 
)t


