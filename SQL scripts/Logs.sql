-- 1. Create External Data Source pointing to medallion container
IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'medallion_ds')
CREATE EXTERNAL DATA SOURCE medallion_ds
WITH (
    LOCATION = 'https://stlakesupply.dfs.core.windows.net/medallion/'
);

-- 2. Create External File Format for CSV
IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'csv_format_skip_header')
CREATE EXTERNAL FILE FORMAT csv_format_skip_header
WITH (
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (
        FIELD_TERMINATOR = ',',
        FIRST_ROW = 2,      -- skip header row
        USE_TYPE_DEFAULT = FALSE
    )
);

-- 3. Create External Table over the control CSV
IF NOT EXISTS (SELECT * FROM sys.external_tables WHERE name = 'ext_ingestion_control')
CREATE EXTERNAL TABLE ext_ingestion_control (
    source_file_name NVARCHAR(200),
    source_container NVARCHAR(100),
    source_name NVARCHAR(100),
    ingestion_status NVARCHAR(20),
    ingestion_time NVARCHAR(50),
    error_message NVARCHAR(MAX)
)
WITH (
    LOCATION = 'control/ingestion_status.csv',
    DATA_SOURCE = medallion_ds,
    FILE_FORMAT = csv_format_skip_header
);

-- 4. Test: show all pending files
SELECT * FROM ext_ingestion_control
WHERE ingestion_status = 'Pending';