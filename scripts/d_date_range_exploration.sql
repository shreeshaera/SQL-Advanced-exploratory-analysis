/*
============================================================================
                      EXPLORING THE DATE RANGE:
      Understanding historical data, order differences and age groups
============================================================================

SQL Functions Used:
- MIN
- MAX
- DATEDIFF
============================================================================
*/

--- Extracting the first, last order, and months range ---
select 
min(order_date) as First_order,
max(order_date) as Last_order,
datediff(month,min(order_date),max(order_date)) as month_difference
from gold.fact_sales

--- Finding the total orders per year ---
select year(order_date) as year, count(*) total_orders
from gold.fact_sales
where order_date is not null
group by year(order_date)
order by year(order_date) desc

--- Finding the age groups ordering the products ---
select datediff(year,birthdate,getdate()) as age,
count(*) as total_customers
from gold.dim_customers 
group by datediff(year,birthdate,getdate()) 
order by total_customers desc 

