/*
===============================================================================
							CUSTOMER REPORT
-------------------------------------------------------------------------------
		This report consolidates key customer metrics and behaviors
===============================================================================

Highlights:
    1. Retrieving ssential fields such as names, ages, and transaction details.
	2. Segment customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculate valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

----- Creating complete customer report -----

------ Retrieving all the relevant columns for the analysis
WITH base_info AS
(
SELECT 
	c.customer_key,
	c.customer_number,
	f.order_number,
	f.product_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	CONCAT(c.first_name,' ',c.last_name) AS customer_name,
	DATEDIFF(YEAR,c.birthdate,GETDATE()) AS age
FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
	ON c.customer_key = f.customer_key
WHERE f.order_date IS NOT NULL 
),

------ Aggregating the customer metrics
customer_aggregations AS
(
SELECT 
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(quantity) AS total_quantity,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT product_key) AS total_products,
	MIN(order_date) AS first_order,
	MAX(order_date) AS last_order,
	DATEDIFF(MONTH,MIN(order_date), MAX(order_date)) AS lifespan
FROM base_info
GROUP BY customer_number,customer_name,age
)

------ Segregating the customers
SELECT
	*, 
	 CASE
		WHEN lifespan >= 12 and total_sales> 5000 THEN 'VIP'
		WHEN lifespan >= 12 and total_sales <= 5000 THEN 'Regular'
	 ELSE 'New'
	 END AS customer_segment,
	 CASE 
		WHEN age < 20 THEN 'Under 20'
		WHEN age between 21 and 30 THEN '21-30'
		WHEN age between 31 and 40 THEN '31-40'
		WHEN age between 41 and 50 THEN '41-50'
	 ELSE 'over 50'
	 END AS customer_age_segment,
	DATEDIFF(MONTH,last_order,GETDATE()) AS recency,
	 CASE 
		WHEN total_Sales = 0 THEN 0
	 ELSE total_sales/total_orders END avg_order_value,
	 CASE 
		WHEN lifespan = 0 THEN total_sales
	 ELSE total_sales/lifespan END avg_monthly_spend  
FROM customer_aggregations


