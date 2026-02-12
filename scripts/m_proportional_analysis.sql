/*
==========================================================================================
                            PROPORTIONAL ANALYSIS
------------------------------------------------------------------------------------------
         To compare performance or metrics across dimensions or time periods.
     and evaluate differences between categories, It is helpful in regional comparisions
==========================================================================================

SQL Functions Used:
    - SUM
    - AVG
    - OVER
    - CAST
===========================================================================================
*/

--- Retrieving the categories contribution to the revenue ---
WITH category_revenue AS
(
SELECT 
    p.category,
    SUM(sales_amount) AS category_total_sales
FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p  
    ON p.product_key = f.product_key
GROUP BY p.category
)

SELECT
    category, 
    category_total_sales,
    SUM(category_total_sales) OVER() AS total_sales,
    CONCAT(ROUND(100 * CAST(category_total_sales AS FLOAT) / 
                 SUM(category_total_sales) OVER(),2 ), ' %')  contribution 
FROM category_revenue
ORDER BY category_total_sales DESC
