CREATE DATABASE supplychain_db;

use supplychain_db;
use gold_db;

CREATE USER [adf-supplychain-1] FROM EXTERNAL PROVIDER;

ALTER ROLE db_owner ADD MEMBER [adf-supplychain-1];
ALTER ROLE db_datareader ADD MEMBER [adf-supplychain-1];

CREATE USER [purview-supplychain-prod] FROM EXTERNAL PROVIDER;
ALTER ROLE db_datareader ADD MEMBER [purview-supplychain-prod];

-- Octroyer la permission d'opération en bloc au niveau de la base de données ou du serveur via un rôle approprié
GRANT ADMINISTER DATABASE BULK OPERATIONS TO [purview-supplychain-prod];

SELECT name FROM sys.database_principals WHERE name = 'adf-supplychain-1';
