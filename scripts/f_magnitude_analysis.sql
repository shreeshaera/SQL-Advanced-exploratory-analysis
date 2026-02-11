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
select country,count(distinct customer_key) as total_customers
from gold.dim_customers 
group by country 
order by total_customers desc

--- Retrieving Total customers by Gender ---
select gender,count(gender) total_customers
from gold.dim_customers
group by gender
order by total_customers desc

--- Retrieving Total products by Category ---
select category,count(distinct product_key) total_products
from gold.dim_products
group by category
order by total_products desc

--- Retrieving Average cost per Category ---
select category, avg(cost) as average_cost
from gold.dim_products
group by category
order by average_cost desc

--- Retrieving Total revenue per Category ---
select p.category, sum(f.sales_amount) total_revenue
from gold.dim_products p
left join gold.fact_sales f
on p.product_key = f.product_key
where p.category is not null
group by p.category
order by total_revenue desc

--- Retrieving Total sales per Customers ---
select c.customer_key, c.first_name, c.last_name, 
sum(f.sales_amount) totalsales
from gold.fact_sales f
left join gold.dim_customers c
on c.customer_key = f.customer_key
group by c.customer_key, c.first_name, c.last_name
order by totalsales desc

--- Total items across Country ---
select c.country, count(f.quantity) total_items
from gold.fact_sales f
left  join gold.dim_customers c
on c.customer_key = f.customer_key
group by c.country
order by total_items desc
