IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseParquetFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseParquetFormat] 
	WITH ( FORMAT_TYPE = PARQUET)
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'taxidata_pstaxisdatalake_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [taxidata_pstaxisdatalake_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://taxidata@pstaxisdatalake.dfs.core.windows.net', 
		TYPE     = HADOOP 
	)
GO

CREATE EXTERNAL TABLE ext.YellowTaxis (
	[VendorID] int,
	[tpep_pickup_datetime] datetime2(7),
	[tpep_dropoff_datetime] datetime2(7),
	[passenger_count] int,
	[trip_distance] float,
	[RatecodeID] int,
	[store_and_fwd_flag] varchar(8000),
	[PULocationID] int,
	[DOLocationID] int,
	[payment_type] int,
	[fare_amount] float,
	[extra] float,
	[mta_tax] float,
	[tip_amount] float,
	[tolls_amount] float,
	[improvement_surcharge] float,
	[total_amount] float,
	[congestion_surcharge] float
	)
	WITH (
	LOCATION = 'YellowTaxis_201911.parquet',
	DATA_SOURCE = [taxidata_pstaxisdatalake_dfs_core_windows_net],
	FILE_FORMAT = [SynapseParquetFormat],
	REJECT_TYPE = VALUE,
	REJECT_VALUE = 0
	)
GO

SELECT TOP 100 * FROM ext.YellowTaxis
GO

-- Create schema 'main' for Dedicated SQL Pool tables
CREATE SCHEMA main
GO

-- Create table main.YellowTaxis, using CTAS (Polybase)
CREATE TABLE main.YellowTaxis
WITH 
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
) 
AS 
SELECT * 
FROM ext.YellowTaxis



SELECT TOP 10000 * FROM main.YellowTaxis



    












