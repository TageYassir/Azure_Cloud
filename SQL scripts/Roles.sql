CREATE DATABASE supplychain_db;

use supplychain_db;

CREATE USER [adf-supplychain-1] FROM EXTERNAL PROVIDER;

ALTER ROLE db_owner ADD MEMBER [adf-supplychain-1];
ALTER ROLE db_datareader ADD MEMBER [adf-supplychain-1];

CREATE USER [purview-supplychain-prod] FROM EXTERNAL PROVIDER;
ALTER ROLE db_datareader ADD MEMBER [purview-supplychain-prod];


SELECT name FROM sys.database_principals WHERE name = 'adf-supplychain-1';
