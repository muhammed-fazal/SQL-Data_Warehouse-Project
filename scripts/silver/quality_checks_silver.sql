/*
============================================================
Quality Checks
============================================================
Script Purpose:
	This script perform various quality checks for data consistency,
	accuracy,
	and standardization across the 'silver' schema. It includes check for:
	- Null or duplicate primary keys.
	- Unwanted spaces in string fields.
	- Data standardization and consistency.
	- Invalid date range and orders.
	data consistency between related fields.

	Usage Notes:
	-- Run these checks after data loading silver layer.
	-- Investigate and resolve any discrepancies found during the checks.

	==============================================================
*/

/*
-- ============================================================
-- Checking 'silver.crm_cust_info'
-- ============================================================
*/
-- Quality Check for 'silver.crm_cust_info'
-- Check for null or Duplicates in Primary Key
-- Expectation : No Result
SELECT
cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for Unwanded Spaces in the string
-- Expectation : No Result
SELECT
cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;

/*
-- ============================================================
-- Checking 'silver.crm_prd_info'
-- ============================================================
*/
-- Quality Check for 'silver.crm_prd_info'
-- Check for null or Duplicates in Primary Key
-- Expectation : No Result
SELECT
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for unwanted Spaces
-- Expectation: No Results
SELECT
prd_id,
prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for NULLs or Negative Number in cost
-- Expectation: No Results
SELECT
prd_id,
prd_nm,
prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization & Consistency
SELECT
DISTINCT prd_line
FROM silver.crm_prd_info;

-- Check for Invalid Date Orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

/*
-- ============================================================
-- Checking 'silver.crm_sales_details'
-- ============================================================
*/

-- Check for Invalid dates
-- Expectation: No results
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- Check data Consistency: Between Sales, Quantity, and Price
-- Expectation: No results
-- >> Sales = Quantity*Price
-- >> Values must not be NULL, zero, or negative.
SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity*sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales,sls_quantity,sls_price;

SELECT * FROM silver.crm_sales_details;


/*
-- ============================================================
-- Checking 'silver.erp_cust_az12'
-- ============================================================
*/

-- identify OUt-of-range dates
SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE();

-- Data Standardization & consistency
SELECT DISTINCT gen
FROM silver.erp_cust_az12;

/*
-- ============================================================
-- Checking 'silver.erp_loc_a101'
-- ============================================================
*/

-- DATA Standardization & Consistency
SELECT DISTINCT
cntry 
FROM silver.erp_loc_a101
ORDER BY cntry;

SELECT* FROM silver.erp_loc_a101;

/*
-- ============================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- ============================================================
*/

-- Check for unwanted spaces
SELECT * FROM silver.erp_px_cat_g1v2
WHERE cat!=TRIM(cat) OR subcat!=TRIM(subcat) OR maintenance!=TRIM(maintenance);

-- DATA standardization & consistency
SELECT DISTINCT
cat
FROM silver.erp_px_cat_g1v2;

SELECT DISTINCT
subcat
FROM silver.erp_px_cat_g1v2;

SELECT DISTINCT
maintenance
FROM silver.erp_px_cat_g1v2;

select * from silver.erp_px_cat_g1v2;
