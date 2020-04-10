CREATE PROCEDURE main.LoadYellowTaxis (@Date VARCHAR(10))
AS 
BEGIN

    /******************************************************************************
        Drop and recreate external table for Yellow Taxis
    ******************************************************************************/
    IF EXISTS (SELECT * FROM sys.external_tables t INNER JOIN sys.schemas s ON t.schema_id = s.schema_id WHERE s.name = 'ext' AND t.name = 'YellowTaxis')
    BEGIN
        DROP EXTERNAL TABLE ext.YellowTaxis
    END
    
    DECLARE @ExternalTableScript NVARCHAR(4000);

    SET @ExternalTableScript = '
        CREATE EXTERNAL TABLE ext.YellowTaxis 
        (
            [VendorID] INT,
            [tpep_pickup_datetime] DATETIME2,
            [tpep_dropoff_datetime] DATETIME2,
            [passenger_count] INT,
            [trip_distance] FLOAT,
            [RatecodeID] INT,
            [store_and_fwd_flag] varchar(100),
            [PULocationID] INT,
            [DOLocationID] INT,
            [payment_type] INT,
            [fare_amount] FLOAT,
            [extra] FLOAT,
            [mta_tax] FLOAT,
            [tip_amount] FLOAT,
            [tolls_amount] FLOAT,
            [improvement_surcharge] FLOAT,
            [total_amount] FLOAT,
            [congestion_surcharge] FLOAT
        )
        WITH 
        (
            LOCATION = ''YellowTaxis_' + @Date + '.parquet'',
            DATA_SOURCE = PSDataLake,
            FILE_FORMAT = SynapseParquetFormat,
            REJECT_TYPE = VALUE,
            REJECT_VALUE = 100
        )'

    EXECUTE sp_executesql @ExternalTableScript;

    /******************************************************************************
        Load data into main.YellowTaxis
    ******************************************************************************/    
    INSERT INTO main.YellowTaxis (VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, 
                                  trip_distance, RatecodeID, store_and_fwd_flag, PULocationID, DOLocationID, 
                                  payment_type, fare_amount, extra, mta_tax, tip_amount, tolls_amount, 
                                  improvement_surcharge, total_amount, congestion_surcharge)
    
    SELECT                        VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, 
                                  trip_distance, RatecodeID, store_and_fwd_flag, PULocationID, DOLocationID, 
                                  payment_type, fare_amount, extra, mta_tax, tip_amount, tolls_amount, 
                                  improvement_surcharge, total_amount, congestion_surcharge
    FROM ext.YellowTaxis;

    /******************************************************************************
        Load the data to Data Lake using CETAS statement
    ******************************************************************************/
    IF EXISTS (SELECT * FROM sys.external_tables t INNER JOIN sys.schemas s ON t.schema_id = s.schema_id WHERE s.name = 'ext' AND t.name = 'ProcessedYellowTaxis')
    BEGIN
        DROP EXTERNAL TABLE ext.ProcessedYellowTaxis
    END

    CREATE EXTERNAL TABLE ext.ProcessedYellowTaxis
    WITH 
    (  
        DATA_SOURCE = PSDataLakeOutput,
        FILE_FORMAT = SynapseParquetFormat,
        LOCATION='/Facts/YellowTaxis.parquet'    
    )
    AS
    SELECT *
    FROM main.YellowTaxis;
    
END
GO


