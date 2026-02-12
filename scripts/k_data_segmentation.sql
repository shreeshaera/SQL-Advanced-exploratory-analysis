/*
========================================================================================
                          DATA SEGMENTATION ANALYSIS
----------------------------------------------------------------------------------------
            To group data into meaningful categories for targeted insights
                 and make rightful decisions by the analysis
=========================================================================================
SQL Functions Used:
    - CASE
    - GROUP BY
    - CTE
========================================================================================
*/

--- Segmenting the products into five different categories based on their costs ---
WITH cost_segmentation AS
(
SELECT 
    product_key,
    CASE
         WHEN cost between 0 and 100 THEN '0-100' 
         WHEN cost between 100 and 500 THEN '100-500'
         WHEN cost between 500 and 1000 THEN '500-1000'
         WHEN cost between 1000 and 5000 THEN '1000-5000'
    ELSE 'above 5000'
    END segmentation
FROM gold.dim_products 
)

SELECT 
segmentation,
COUNT(product_key) AS total_products
FROM cost_segmentation
GROUP BY segmentation
ORDER BY segmentation;

--- Segmenting the customers into three different categories according to their order history ---
 WITH customer_segmentation AS
(
SELECT 
    c.customer_key,
    CASE
        WHEN DATEDIFF(MONTH,MIN(f.order_date), MAX(f.order_date)) >= 12 and SUM(f.sales_amount) > 5000 
        THEN 'VIP'
        WHEN DATEDIFF(MONTH,MIN(f.order_date), MAX(f.order_date)) >= 12 and SUM(f.sales_amount) <= 5000 
        THEN 'Regular'
    ELSE 'New'
    END spending_behaviour
FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
GROUP BY c.customer_key

)
SELECT 
    spending_behaviour, 
    COUNT(customer_key) AS total_customers
FROM customer_segmentation
GROUP BY spending_behaviour
ORDER BY total_customers DESC


