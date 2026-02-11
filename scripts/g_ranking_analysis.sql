/*
================================================================================
							RANKING ANALYSIS
Interpretating the customer behaviour by ranking the products and their orders
================================================================================

SQL Functions Used:
    - Window Ranking Functions: RANK, DENSE_RANK, ROW_NUMBER, TOP
    - GROUP BY, ORDER 
================================================================================
*/

--- Extracting Top 5 products in revenue ---
SELECT TOP 5 
    p.product_name,
    SUM(f.sales_amount) total_revenue
FROM gold.fact_sales f 
    left join gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC

--- Extracting Worst 5 products in revenue ---
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue

--- Extracting Top 10 customers based on their total sales ---
SELECT TOP 10 
    c.customer_key,
    c.first_name, 
    c.last_name, 
    SUM(f.sales_amount) totalsales
FROM gold.fact_sales f
    left join gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY totalsales DESC

--- Extracting lowest 3 customers based on their total orders ---
SELECT TOP 3
    c.customer_key, 
    c.first_name,
    c.last_name, 
    COUNT(DISTINCT f.order_number) totalorders
FROM gold.fact_sales f
    left join gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY totalorders 
