IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'TaxiZonesCopy' AND O.TYPE = 'U' AND S.NAME = 'main')
CREATE TABLE main.TaxiZonesCopy
	(
	 [LocationID] bigint,
	 [Borough] nvarchar(500),
	 [Zone] nvarchar(500),
	 [ServiceZone] nvarchar(500)
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX	 
	)
GO

COPY INTO main.TaxiZonesCopy
(LocationID 1, Borough 2, Zone 3, ServiceZone 4)
FROM 'https://pstaxisdatalake.dfs.core.windows.net/taxidata/TaxiZones/*.csv'
WITH
(
	FILE_TYPE = 'CSV'
	,MAXERRORS = 10
	,FIRSTROW = 2
	,ERRORFILE = 'https://pstaxisdatalake.dfs.core.windows.net/taxidata/ErrorRows/TaxiZones2'
	,IDENTITY_INSERT = 'OFF'
)
--END
GO

SELECT TOP 100 * FROM main.TaxiZonesCopy
GO




