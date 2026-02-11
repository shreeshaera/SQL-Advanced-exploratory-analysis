/*
===============================================================================
                    EXPLORING THE DATABASE TABLES AND 
         ITS CORRESPONDING INFORMATION (LIKE DATA_TYPE,TABLE_SCHEMA ETC)
 ===============================================================================
*/

SELECT * 
FROM INFORMATION_SCHEMA.TABLES

---- Retrieving Information about the database columns, schema, catalog ----
SELECT
TABLE_CATALOG,
TABLE_SCHEMA,
TABLE_NAME,
COLUMN_NAME,
DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS


--- Retrieving information from a specific table ---
SELECT 
    TABLE_NAME
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales';
