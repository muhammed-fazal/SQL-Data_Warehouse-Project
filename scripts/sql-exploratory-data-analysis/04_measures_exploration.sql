/*=============================================================================
MEASURES EXPLORATION( key Metrics):

Calculate the key metric of the business ( Bib Numbers)
	- Highest Level od aggregation | Lowest Level of details
	- To identify overall trends or spot anomalies.
	
	1) Find the Total Sales
	2) Find how many items are sold
	3) Find the average selling price
	4) Find the Total Number of Orders
	5) Find the Total Number of products
	6) Find the Total Number of Customers
	7) Find the Total number of Customers that has placed an order
	8) Genarete a report that all key metrics of the business
===============================================================================*/

-- 1.Find the Total Sales
SELECT SUM(sales_amount) AS Total_Sales FROM gold.fact_sales;

-- 2.Find how many items are sold
SELECT SUM(quantity) AS Items_sold FROM gold.fact_sales;

-- 3.Find the average selling price
SELECT AVG(price) AS Avg_price FROM gold.fact_sales;

-- 4.Find the Total Number of Orders
SELECT COUNT(DISTINCT(order_number)) AS No_of_orders FROM gold.fact_sales;

-- 5.Find the Total Number of products
SELECT COUNT(DISTINCT(product_name)) AS No_of_products FROM gold.dim_products;
SELECT COUNT(product_key) AS No_of_products FROM gold.dim_products;

-- 6.Find the Total Number of Customers
SELECT COUNT(DISTINCT(customer_key)) AS No_of_Customers FROM gold.dim_customers;

-- 7.Find the Total number of Customers that has placed an order
SELECT COUNT(DISTINCT(customer_key)) AS No_of_customer_placed_order FROM gold.fact_sales
WHERE order_number IS NOT NULL;

-- 8.Genarete a report that all key metrics of the business
SELECT 'Total Sales' AS measure_name ,SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Items_sold', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Orders', COUNT(DISTINCT(order_number)) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Products', COUNT(DISTINCT(product_name)) FROM gold.dim_products
UNION ALL
SELECT 'Total Nr. Customers', COUNT(DISTINCT(customer_key)) FROM gold.dim_customers
UNION ALL
SELECT 'Total Nr. Customers_with_order', COUNT(DISTINCT(customer_key)) FROM gold.dim_customers;

