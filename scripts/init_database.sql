/*
=============================================================
CREATE DATABASE AND SCHEMAS 
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouseAnalytics' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, this script creates a schema called gold
*/

USE master;
GO

-------------------------------------------------------------------
--  CHECKING EXISITING DATABASES 
-------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
END;
GO

-------------------------------------------------------------------
--  CREATING A DATABASE 
-------------------------------------------------------------------
CREATE DATABASE DataWarehouseAnalytics;
GO

USE DataWarehouseAnalytics;
GO

-------------------------------------------------------------------
--  CREATING SCHEMAS
-------------------------------------------------------------------
CREATE SCHEMA gold;
GO

-------------------------------------------------------------------
--  CREATING TABLES
-------------------------------------------------------------------
-- Creating table dim_customers under gold scheme
CREATE TABLE gold.dim_customers(
	customer_key int,
	customer_id int,
	customer_number nvarchar(50),
	first_name nvarchar(50),
	last_name nvarchar(50),
	country nvarchar(50),
	marital_status nvarchar(50),
	gender nvarchar(50),
	birthdate date,
	create_date date
);
GO

-- Creating table dim_products under gold scheme
CREATE TABLE gold.dim_products(
	product_key int ,
	product_id int ,
	product_number nvarchar(50) ,
	product_name nvarchar(50) ,
	category_id nvarchar(50) ,
	category nvarchar(50) ,
	subcategory nvarchar(50) ,
	maintenance nvarchar(50) ,
	cost int,
	product_line nvarchar(50),
	start_date date 
);
GO

-- Creating table fact_sales under gold scheme
CREATE TABLE gold.fact_sales(
	order_number nvarchar(50),
	product_key int,
	customer_key int,
	order_date date,
	shipping_date date,
	due_date date,
	sales_amount int,
	quantity tinyint,
	price int 
);
GO

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Truncating the whole table, if the table has any exisiting information and
-- Inserting the columns and rows into the three tables
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

TRUNCATE TABLE gold.dim_customers;
GO


BULK INSERT gold.dim_customers
FROM 'C:\Users\sribalaji\Downloads\SQL\dim_customers.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.dim_products;
GO

BULK INSERT gold.dim_products
FROM 'C:\Users\sribalaji\Downloads\SQL\dim_products.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.fact_sales;
GO

BULK INSERT gold.fact_sales
FROM 'C:\Users\sribalaji\Downloads\SQL\fact_sales.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO
