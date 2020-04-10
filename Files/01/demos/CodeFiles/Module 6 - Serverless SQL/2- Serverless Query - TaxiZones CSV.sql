-- This is auto-generated code
SELECT
    TOP 100 *
FROM
    OPENROWSET(
    BULK 'https://pstaxisdatalake.dfs.core.windows.net/taxidata/TaxiZones/TaxiZones1.csv',
        FORMAT = 'CSV',
        PARSER_VERSION='2.0',
        HEADER_ROW = TRUE
    ) AS [result]



SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://pstaxisdatalake.dfs.core.windows.net/taxidata/TaxiZones/TaxiZones1.csv',
        FORMAT = 'CSV',
        PARSER_VERSION='2.0',
        HEADER_ROW = TRUE
    )
    WITH (
        LocationId INT               1,
        Borough VARCHAR(100)         2,
        Zone VARCHAR(100)            3,
        ServiceZone VARCHAR(100)     4
    ) AS zones

























