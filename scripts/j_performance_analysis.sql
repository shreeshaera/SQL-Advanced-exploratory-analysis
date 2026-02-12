/*
=================================================================================================
                PERFORMANCE ANALYSIS (YEAR-OVER-YEAR, MONTH-OVER-MONTH)
-------------------------------------------------------------------------------------------------
       To measure the performance of products, customers, or regions over time and
                        To track yearly trends and growth.
=================================================================================================

SQL Functions Used:
    - LAG
    - AVG
    - OVER
    - CASE 
=================================================================================================
*/

--- Analysing yearly performance of products to both avgerage price and previous year sales ---
WITH current_year_sales AS
(
SELECT
    p.product_name,
    YEAR(s.order_date) AS YEAR,
    SUM(s.sales_amount) AS current_sales
FROM gold.fact_sales s 
    LEFT JOIN gold.dim_products p
    ON p.product_key = s.product_key
WHERE YEAR(order_date) IS NOT NULL 
GROUP BY YEAR(order_date) , p.product_name
),

previous_year_sales AS
(
SELECT *,
    AVG(current_sales) OVER(PARTITION BY product_name) AS average,
    LAG(current_sales) OVER(PARTITION BY product_name ORDER BY YEAR) AS previous_sales
FROM current_year_sales
)

SELECT 
    product_name,
    YEAR AS Year,
    current_sales,
    average,
    (current_sales - average) AS diff_avg,
    CASE 
        WHEN (current_sales - average) < 0 THEN 'Below Avg'
        WHEN (current_sales - average) > 0 THEN 'Above Avg'
        ELSE 'Average'
    END AS comparision,
    previous_sales,
    (current_sales - previous_sales) AS diff_sales,
    CASE 
        WHEN (current_sales - previous_sales)< 0 THEN 'Decreasing'
        WHEN (current_sales - previous_sales) > 0 THEN 'Increasing'
        ELSE 'Same'
    END YOY_growth
FROM previous_year_sales
ORDER BY product_name,year 
