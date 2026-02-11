/*
====================================================================
				 EXPLORING THE DIMENSIONS TABLE:
	To understand Customer and Product dimensions and relations
====================================================================
FUNCTIONS USED:
 - DISTINCT
 - TOP
 - GROUP BY
 - ORDER 
=====================================================================
 */

---- Retrieve distinct countries 
SELECT DISTINCT country
FROM gold.dim_customers

---- Retrieve distinct Product Names
SELECT DISTINCT product_name 
FROM gold.dim_products

---- Retrieve distinct Category, Subcategory 
SELECT  DISTINCT category,subcategory
FROM gold.dim_products
GROUP BY category,subcategory

---- Retrieve Distinct Top 5 categories 
SELECT DISTINCT  TOP 5 (category)
FROM gold.dim_products
WHERE category is not null
ORDER BY category
