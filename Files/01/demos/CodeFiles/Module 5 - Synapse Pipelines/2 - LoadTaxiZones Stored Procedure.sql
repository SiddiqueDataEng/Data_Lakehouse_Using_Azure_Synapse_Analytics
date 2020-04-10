CREATE PROCEDURE main.LoadTaxiZones
AS 
BEGIN
    
    /******************************************************************************
        Create or truncate main.TaxiZones
    ******************************************************************************/
    IF NOT EXISTS (SELECT * FROM sys.tables t INNER JOIN sys.schemas s ON t.schema_id = s.schema_id WHERE s.name = 'main' AND t.name = 'TaxiZones')
        BEGIN
            CREATE TABLE main.TaxiZones
            (
                LocationId INT,
                [Borough] nvarchar(100),
                [Zone] nvarchar(100),
                [ServiceZone] nvarchar(100)
            )
            WITH
            (
                DISTRIBUTION = HASH(LocationId),
                CLUSTERED COLUMNSTORE INDEX            
            )
        END
    ELSE
        BEGIN
            TRUNCATE TABLE main.TaxiZones
        END

    /******************************************************************************
        Copy data to main.TaxiZones table
    ******************************************************************************/
    COPY INTO main.TaxiZones
        (LocationId 1, Borough 2, Zone 3, ServiceZone 4)
    FROM 'https://pstaxisdatalake.dfs.core.windows.net/taxidata/TaxiZones/*.csv'
    WITH
    (
          FILE_TYPE = 'CSV'
        , MAXERRORS = 10
        , FIRSTROW = 2
        , ERRORFILE = 'https://pstaxisdatalake.dfs.core.windows.net/taxidata/Errors/TaxiZones'
        , IDENTITY_INSERT = 'OFF'
    )

    /******************************************************************************
        Load the data to Data Lake using CETAS statement
    ******************************************************************************/
    IF NOT EXISTS (SELECT * FROM sys.external_data_sources d WHERE d.name = 'PSDataLakeOutput')
    BEGIN
        CREATE EXTERNAL DATA SOURCE PSDataLakeOutput
        WITH 
        (  
            TYPE = HADOOP,
            LOCATION ='abfss://taxioutput@pstaxisdatalake.dfs.core.windows.net',  
            CREDENTIAL = PSDataLakeCredential  
        )
    END

    IF EXISTS (SELECT * FROM sys.external_tables t INNER JOIN sys.schemas s ON t.schema_id = s.schema_id WHERE s.name = 'ext' AND t.name = 'ProcessedTaxiZones')
    BEGIN
        DROP EXTERNAL TABLE ext.ProcessedTaxiZones
    END

    CREATE EXTERNAL TABLE ext.ProcessedTaxiZones
    WITH 
    (  
        DATA_SOURCE = PSDataLakeOutput,
        FILE_FORMAT = SynapseParquetFormat,
        LOCATION='/Dimensions/TaxiZones.parquet'    
    )
    AS
    SELECT *
    FROM ext.TaxiZones;
    
END
GO
