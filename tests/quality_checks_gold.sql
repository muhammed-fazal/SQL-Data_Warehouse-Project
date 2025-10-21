/* 
=================================================================
Quality Checks
=================================================================

Script Purpose:
	This script perform quality checks validate the integrity, consistency,
	and accuracy of the Gold layer
	These checks ensure:
	- Uniqueness of surrogate keys in dimension tables.
	- Referential integrity between fact and dimension tables.
	- Validation of relationship in the data model for analytical purposes.

Usage notes:
	- Run these checks after data loading Silver layer.
	- Investigate and resolve any discrepancies found during the checks

	=================================================================

*/

-- =================================================================
-- Checking:gold.dim_customers
-- =================================================================
-- Expectation: No Results
SELECT 
	customer_key,
	COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- If the two table have same columns then check its matches perfectly or else we need to integrate the columns
SELECT
	ci.cst_gndr,
	ca.gen,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
	ELSE COALESCE(ca.gen, 'n/a')
	END AS new_gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid
ORDER BY 1,2


-- Checking the View have distinct gender
SELECT DISTINCT gender
FROM gold.dim_customers;


-- =================================================================
-- Checking:gold.dim_products
-- =================================================================
-- Check duplicate in in 'prd_key'
SELECT
	product_key,
	COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) >1;

-- =================================================================
-- Checking:gold.fact_sales
-- =================================================================
-- Fact Check
-- Check if all dimention tables can successfully join yo the act table
SELECT *
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers ct
ON fs.customer_key = ct.customer_key
LEFT JOIN gold.dim_products pd
ON fs.product_key = pd.product_key
WHERE pd.product_key IS NULL
