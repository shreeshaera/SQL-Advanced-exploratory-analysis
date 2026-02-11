/*
===============================================================================
                         MAGNITUDE ANALYSIS
      Understanding the customers and products  sales, profits, trending items
===============================================================================

SQL functions used:
    - Aggregate Functions: SUM, COUNT, AVG
    - GROUP BY, ORDER BY
===============================================================================
*/

--- Retrieving Total customers per country ---
SELECT 
    country,
    COUNT(DISTINCT customer_key) AS total_customers
FROM gold.dim_customers 
GROUP BY country 
ORDER BY total_customers DESC

--- Retrieving Total customers by Gender ---
SELECT 
    gender,
    COUNT(gender) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC

--- Retrieving Total products by Category ---
SELECT 
    category,
    COUNT(DISTINCT product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC

--- Retrieving Average cost per Category ---
SELECT
    category,
    AVG(cost) AS average_cost
FROM gold.dim_products
GROUP BY category
ORDER BY average_cost DESC

--- Retrieving Total revenue per Category ---
SELECT 
    p.category, 
    SUM(f.sales_amount) AS total_revenue
FROM gold.dim_products p
    left join gold.fact_sales f
    ON p.product_key = f.product_key
WHERE p.category is not null
GROUP BY p.category
ORDER BY total_revenue DESC

--- Retrieving Total sales per Customers ---
SELECT
    c.customer_key, 
    c.first_name, 
    c.last_name, 
    SUM(f.sales_amount) AS totalsales
FROM gold.fact_sales f
    left join gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY totalsales DESC

--- Total items across Country ---
SELECT 
    c.country,
    COUNT(f.quantity) AS total_items
FROM gold.fact_sales f
    left  join gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_items DESC
