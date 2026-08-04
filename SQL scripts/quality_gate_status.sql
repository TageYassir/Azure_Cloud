-- Create an external data source if you don't already have one pointing to medallion container
-- (You likely already have one from the ingestion control setup; adapt the name)
CREATE EXTERNAL DATA SOURCE medallion_src
WITH (
    LOCATION = 'https://stlakesupply.dfs.core.windows.net/medallion/'
);

-- Use the same CSV file format you've used for ingestion_status
-- (Assuming it parses headers, comma-delimited, etc.)
CREATE EXTERNAL FILE FORMAT csv_with_header
WITH (
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (FIELD_TERMINATOR = ',', FIRST_ROW = 2)   -- skip header row
);

-- External table pointing to the quality gate CSV
CREATE EXTERNAL TABLE ext_quality_gate_status (
    entity_name        VARCHAR(50),
    processing_date    DATE,          -- 7/23/2026 → interpreted as date, ensure format matches
    status             VARCHAR(10),
    details            VARCHAR(1000)
)
WITH (
    LOCATION = 'control/quality_gate_status.csv',
    DATA_SOURCE = medallion_src,
    FILE_FORMAT = csv_with_header
);