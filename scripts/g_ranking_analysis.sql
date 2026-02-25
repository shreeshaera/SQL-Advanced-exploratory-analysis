/*
================================================================================
							RANKING ANALYSIS
--------------------------------------------------------------------------------
Interpretating the customer behaviour by ranking the products and their orders
================================================================================

SQL Functions Used: 
    - RANK
    - GROUP BY
    - ORDER
    - TOP
    - SUM
    - COUNT
    - JOINS
================================================================================
*/

--- Extracting Top 5 products in revenue ---
SELECT TOP 5 
    p.product_name,
    SUM(f.sales_amount)  AS total_revenue
FROM gold.fact_sales f 
    left join gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC

--- Extracting Worst 5 products in revenue ---
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) ) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

--- Extracting Top 10 customers based on their total sales ---
SELECT TOP 10 
    c.customer_key,
    c.first_name, 
    c.last_name, 
    SUM(f.sales_amount) AS totalsales
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
    COUNT(DISTINCT f.order_number) AS totalorders
FROM gold.fact_sales f
    left join gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY totalorders 
