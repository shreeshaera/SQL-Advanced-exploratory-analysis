/*
================================================================================================
                                PRODUCT REPORT
------------------------------------------------------------------------------------------------
                This report retrieves key product metrics and behaviors.
================================================================================================

Highlights:
    1. Gather important fields such as product name, category, subcategory, and cost.
    2. Segment products by revenue 
    3. Aggregate product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculate valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
=================================================================================================
*/


----------------------======== Creating complete product report ========-------------------------

------ Retrieving all the relevant columns for the analysis
WITH product_information AS
(
SELECT
    p.product_key,
    p.product_name,
    p.category,
    p.subcategory,
    p.cost,
    f.customer_key,
    f.quantity,
    f.order_date,
    f.order_number,
    f.sales_amount
FROM gold.dim_products p
    LEFT JOIN gold.fact_sales f
    ON p.product_key = f.product_key
WHERE f.order_date IS NOT NULL),

------ Aggregating the product metrics
product_aggregation AS 
(
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    COUNT(DISTINCT order_number) AS total_orders,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order,
    DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS lifespan,
    ROUND(AVG(CAST(sales_amount AS FLOAT)/NULLIF(quantity,0)),1) AS avg_selling_price
FROM product_information
GROUP BY product_key,product_name, category,subcategory,cost
)

------ Segregating the products
SELECT 
    *,
     CASE
        WHEN  total_sales> 50000 THEN 'High Performer'
        WHEN total_sales <= 10000 THEN 'Mid Range'
        ELSE 'Low-Performer'
     END customer_segment,
    DATEDIFF(MONTH,last_order,GETDATE()) recency,
     CASE
        WHEN total_Sales = 0 THEN 0
     ELSE total_sales/total_orders
     END avg_order_revenue,
     CASE 
        WHEN lifespan = 0 THEN 0
     ELSE total_sales/lifespan
     END avg_monthly_order
FROM product_aggregation
