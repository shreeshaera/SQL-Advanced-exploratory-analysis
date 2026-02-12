/*
=========================================================================================================
									CHANGE OVER TIME ANALYSIS
----------------------------------------------------------------------------------------------------------
					To understand trends, growth and change in key metrics and
				  To identify seasonality and track decline / growth over periods 
=========================================================================================================

 SQL Functions Used:
    - Date Functions: DATETRUNC, YEAR, FORMAT
    - Aggregate Functions: SUM, COUNT, AVG
=========================================================================================================
*/

--- Analysing orders over years using date functions ---
--Using YEAR,MONTH:
SELECT 
	YEAR(order_date) AS order_year,
	MONTH(order_date) AS order_month,
	COUNT(distinct customer_key) AS total_customers,
	SUM(quantity) AS total_quantity,
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)

-- Using DATETRUNC:
SELECT
    DATETRUNC(month, order_date) AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);

-- Using FORMAT:
SELECT
    FORMAT(order_date, 'yyyy-MMM') AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM');
