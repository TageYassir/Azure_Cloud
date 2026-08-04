@concat('USE gold_db;

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = ''silver_data'')
    EXEC(''CREATE EXTERNAL DATA SOURCE silver_data WITH ( LOCATION = ''''abfss://medallion@stlakesupply.dfs.core.windows.net/silver/'''' );'');

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = ''gold_data'')
    EXEC(''CREATE EXTERNAL DATA SOURCE gold_data WITH ( LOCATION = ''''abfss://medallion@stlakesupply.dfs.core.windows.net/gold/'''' );'');

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = ''parquet_snappy'')
    EXEC(''CREATE EXTERNAL FILE FORMAT parquet_snappy WITH ( FORMAT_TYPE = PARQUET, DATA_COMPRESSION = ''''org.apache.hadoop.io.compress.SnappyCodec'''' );'');

DECLARE @processing_date VARCHAR(10) = ''', pipeline().parameters.processing_date, ''';
DECLARE @year  VARCHAR(4) = SUBSTRING(@processing_date, 1, 4);
DECLARE @month VARCHAR(2) = SUBSTRING(@processing_date, 6, 2);
DECLARE @day   VARCHAR(2) = SUBSTRING(@processing_date, 9, 2);
DECLARE @sql NVARCHAR(MAX);

SET @sql = ''
CREATE OR ALTER VIEW dim_supplier AS
SELECT
    ROW_NUMBER() OVER (ORDER BY supplier_id) AS supplier_sk,
    supplier_id,
    supplier_name,
    country,
    region,
    category,
    lead_time_days,
    quality_score,
    GETDATE() AS etl_created_date
FROM OPENROWSET(
    BULK ''''suppliers/year='' + @year + ''/month='' + @month + ''/day='' + @day + ''/*.parquet'''',
    DATA_SOURCE = ''''silver_data'''',
    FORMAT = ''''PARQUET''''
) AS s;'';
EXEC sp_executesql @sql;

SET @sql = ''
CREATE OR ALTER VIEW dim_product AS
SELECT
    ROW_NUMBER() OVER (ORDER BY product_id) AS product_sk,
    product_id,
    NULL AS product_description,
    NULL AS product_category
FROM (
    SELECT DISTINCT product_id 
    FROM OPENROWSET(BULK ''''purchase_orders/year='' + @year + ''/month='' + @month + ''/day='' + @day + ''/*.parquet'''', DATA_SOURCE = ''''silver_data'''', FORMAT = ''''PARQUET'''') AS po
    UNION
    SELECT DISTINCT product_id 
    FROM OPENROWSET(BULK ''''inventory/year='' + @year + ''/month='' + @month + ''/day='' + @day + ''/*.parquet'''', DATA_SOURCE = ''''silver_data'''', FORMAT = ''''PARQUET'''') AS inv
) AS p;'';
EXEC sp_executesql @sql;

SET @sql = ''
CREATE OR ALTER VIEW dim_warehouse AS
SELECT
    ROW_NUMBER() OVER (ORDER BY warehouse_id) AS warehouse_sk,
    warehouse_id,
    NULL AS warehouse_name,
    NULL AS location,
    NULL AS region
FROM (
    SELECT DISTINCT warehouse_id 
    FROM OPENROWSET(BULK ''''purchase_orders/year='' + @year + ''/month='' + @month + ''/day='' + @day + ''/*.parquet'''', DATA_SOURCE = ''''silver_data'''', FORMAT = ''''PARQUET'''') AS po
    UNION
    SELECT DISTINCT warehouse_id 
    FROM OPENROWSET(BULK ''''inventory/year='' + @year + ''/month='' + @month + ''/day='' + @day + ''/*.parquet'''', DATA_SOURCE = ''''silver_data'''', FORMAT = ''''PARQUET'''') AS inv
) AS w;'';
EXEC sp_executesql @sql;

IF NOT EXISTS (SELECT * FROM sys.external_tables WHERE name = ''dim_date'')
    EXEC(''
    CREATE EXTERNAL TABLE dim_date
    WITH ( LOCATION = ''''dim_date/'''', DATA_SOURCE = gold_data, FILE_FORMAT = parquet_snappy ) AS
    WITH
    E1(N) AS (SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1
              UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1),
    E2(N) AS (SELECT 1 FROM E1 a, E1 b),
    E4(N) AS (SELECT 1 FROM E2 a, E2 b),
    Tally(n) AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 FROM E4)
    SELECT
        CAST(CONVERT(VARCHAR(8), d, 112) AS INT) AS date_sk,
        d AS full_date,
        YEAR(d) AS year,
        MONTH(d) AS month,
        DAY(d) AS day,
        DATENAME(WEEKDAY, d) AS day_of_week,
        DATEPART(QUARTER, d) AS quarter,
        CASE WHEN MONTH(d) <= 6 THEN 1 ELSE 2 END AS half
    FROM (
        SELECT DATEADD(DAY, n, ''''2024-01-01'''') AS d
        FROM Tally
        WHERE DATEADD(DAY, n, ''''2024-01-01'''') <= ''''2028-12-31''''
    ) AS dates;'');

IF EXISTS (SELECT * FROM sys.external_tables WHERE name = ''fact_orders_temp'')
    EXEC(''DROP EXTERNAL TABLE fact_orders_temp;'');

SET @sql = ''
CREATE EXTERNAL TABLE fact_orders_temp
WITH (
    LOCATION = ''''fact_orders/year='' + @year + ''/month='' + @month + ''/day='' + @day + ''/'''',
    DATA_SOURCE = gold_data,
    FILE_FORMAT = parquet_snappy
) AS
SELECT
    CAST(CONVERT(VARCHAR(8), o.order_date, 112) AS INT) AS order_date_sk,
    ds.supplier_sk,
    dp.product_sk,
    dw.warehouse_sk,
    o.order_id,
    o.quantity_ordered,
    o.unit_cost_eur,
    o.total_value_eur,
    o.status,
    o.processing_date AS snapshot_date
FROM OPENROWSET(
    BULK ''''purchase_orders/year='' + @year + ''/month='' + @month + ''/day='' + @day + ''/*.parquet'''',
    DATA_SOURCE = ''''silver_data'''',
    FORMAT = ''''PARQUET''''
) AS o
LEFT JOIN dim_supplier ds ON o.supplier_id = ds.supplier_id
LEFT JOIN dim_product dp ON o.product_id = dp.product_id
LEFT JOIN dim_warehouse dw ON o.warehouse_id = dw.warehouse_id;'';
EXEC sp_executesql @sql;

IF EXISTS (SELECT * FROM sys.external_tables WHERE name = ''fact_orders_temp'')
    EXEC(''DROP EXTERNAL TABLE fact_orders_temp;'');

IF EXISTS (SELECT * FROM sys.external_tables WHERE name = ''fact_deliveries_temp'')
    EXEC(''DROP EXTERNAL TABLE fact_deliveries_temp;'');

SET @sql = ''
CREATE EXTERNAL TABLE fact_deliveries_temp
WITH (
    LOCATION = ''''fact_deliveries/year='' + @year + ''/month='' + @month + ''/day='' + @day + ''/'''',
    DATA_SOURCE = gold_data,
    FILE_FORMAT = parquet_snappy
) AS
SELECT
    CAST(CONVERT(VARCHAR(8), d.actual_delivery_date, 112) AS INT) AS delivery_date_sk,
    CAST(CONVERT(VARCHAR(8), o.order_date, 112) AS INT) AS order_date_sk,
    ds.supplier_sk,
    dp.product_sk,
    dw.warehouse_sk,
    d.delivery_id,
    d.order_id,
    d.quantity_delivered,
    d.quantity_accepted,
    d.quantity_rejected,
    d.delivery_status,
    d.carrier,
    d.processing_date AS snapshot_date
FROM OPENROWSET(
    BULK ''''deliveries/year='' + @year + ''/month='' + @month + ''/day='' + @day + ''/*.parquet'''',
    DATA_SOURCE = ''''silver_data'''',
    FORMAT = ''''PARQUET''''
) AS d
LEFT JOIN OPENROWSET(
    BULK ''''purchase_orders/year='' + @year + ''/month='' + @month + ''/day='' + @day + ''/*.parquet'''',
    DATA_SOURCE = ''''silver_data'''',
    FORMAT = ''''PARQUET''''
) AS o ON d.order_id = o.order_id
LEFT JOIN dim_supplier ds ON o.supplier_id = ds.supplier_id
LEFT JOIN dim_product dp ON o.product_id = dp.product_id
LEFT JOIN dim_warehouse dw ON o.warehouse_id = dw.warehouse_id;'';
EXEC sp_executesql @sql;

IF EXISTS (SELECT * FROM sys.external_tables WHERE name = ''fact_deliveries_temp'')
    EXEC(''DROP EXTERNAL TABLE fact_deliveries_temp;'');

EXEC(''
CREATE OR ALTER VIEW fact_orders AS
SELECT
    CAST(r.filepath(1) AS INT) AS year,
    CAST(r.filepath(2) AS INT) AS month,
    CAST(r.filepath(3) AS INT) AS day,
    r.*
FROM OPENROWSET(
    BULK ''''fact_orders/year=*/month=*/day=*/*.parquet'''',
    DATA_SOURCE = ''''gold_data'''',
    FORMAT = ''''PARQUET''''
) AS r;'');

EXEC(''
CREATE OR ALTER VIEW fact_deliveries AS
SELECT
    CAST(r.filepath(1) AS INT) AS year,
    CAST(r.filepath(2) AS INT) AS month,
    CAST(r.filepath(3) AS INT) AS day,
    r.*
FROM OPENROWSET(
    BULK ''''fact_deliveries/year=*/month=*/day=*/*.parquet'''',
    DATA_SOURCE = ''''gold_data'''',
    FORMAT = ''''PARQUET''''
) AS r;'');')