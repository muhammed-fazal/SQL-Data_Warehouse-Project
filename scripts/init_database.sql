/*
===================================================================
Create Database and Schemas
===================================================================
Script Purpose:
  This script create a new database named 'DataWarehouse' after checking if it already exists.
  If the database exists, it is droped and recreated. additionally, the script sets up three schemas within the database:'bronze' ,'silver' , 'gold'.

WARNING:
  Running this script will drop the entire 'DataWarehouse' database if it exits.
  All data in the database will be permanently dateted. Proceed with caution and ensure you have proper backups before runnig this scripts.
*/


USE master;
-- Drop and recreate the 'DataWarehouse' database
IF EXISTS(SELECT 1 FROM sys.databases WHERE name ='DataWarehouse')
BEGIN 
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO


-- Create Database 'DataWarehouse'

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create SchemasMMMm
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

