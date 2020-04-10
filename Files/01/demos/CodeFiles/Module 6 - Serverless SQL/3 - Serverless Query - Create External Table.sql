IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseParquetFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseParquetFormat] 
	WITH ( FORMAT_TYPE = PARQUET)
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'taxioutput_pstaxisdatalake_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [taxioutput_pstaxisdatalake_dfs_core_windows_net] 
	WITH (
		LOCATION   = 'https://pstaxisdatalake.dfs.core.windows.net/taxioutput', 
	)
Go

CREATE EXTERNAL TABLE RateCodesExternal (
	[RateCodeId] int,
	[RateCode] varchar(8000),
	[Approved] bit
	)
	WITH (
	LOCATION = 'Dimensions/RateCodes.parquet',
	DATA_SOURCE = [taxioutput_pstaxisdatalake_dfs_core_windows_net],
	FILE_FORMAT = [SynapseParquetFormat]
	)
GO

SELECT TOP 100 * FROM RateCodesExternal
GO

