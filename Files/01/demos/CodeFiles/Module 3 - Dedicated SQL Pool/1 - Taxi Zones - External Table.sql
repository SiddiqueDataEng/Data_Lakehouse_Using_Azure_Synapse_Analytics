-- Create master key
CREATE MASTER KEY;
GO

-- Create credential to access Data Lake
CREATE DATABASE SCOPED CREDENTIAL PSDataLakeCredential
WITH 
	IDENTITY = 'user', 
	Secret = 'puD0uVgUHzWvl0jz55Bm9dvmvjchKMluio9lovcXUbeE84ubk7e8Oa2F//Bdv/cyN6teK21DLrdMyn/wzLj/WQ==';
GO

-- Create external data source, pointing to Data Lake
CREATE EXTERNAL DATA SOURCE PSDataLake
with (  
      TYPE = HADOOP,
      LOCATION ='abfss://taxidata@pstaxisdatalake.dfs.core.windows.net',  
      CREDENTIAL = PSDataLakeCredential  
);  
GO

-- Create external file format
CREATE EXTERNAL FILE FORMAT CSVFileFormat 
WITH 
(   FORMAT_TYPE = DELIMITEDTEXT
,   FORMAT_OPTIONS  
	(   
		FIELD_TERMINATOR   = ','
		, STRING_DELIMITER = '"'
        , DATE_FORMAT      = 'yyyy-MM-dd HH:mm:ss'
        , USE_TYPE_DEFAULT = FALSE
        , FIRST_ROW  = 2
    )
);
GO

-- Create schema for external resources
CREATE SCHEMA ext
GO

-- Create external table for Taxi Zones
CREATE EXTERNAL TABLE ext.TaxiZones
(
	LocationId INT,
	Borough NVARCHAR(100),
	Zone NVARCHAR(100),
    ServiceZone NVARCHAR(100)
)
WITH
(
    DATA_SOURCE = PSDataLake
  , FILE_FORMAT = CSVFileFormat  
  , LOCATION='/TaxiZones/TaxiZones1.csv'  
)
GO

SELECT * FROM ext.TaxiZones
GO







-- Drop external table
DROP EXTERNAL TABLE ext.TaxiZones

-- Recreate external table
CREATE EXTERNAL TABLE ext.TaxiZones
(
	LocationId INT,
	Borough NVARCHAR(100),
	Zone NVARCHAR(100),
    ServiceZone NVARCHAR(100)
)
WITH
(
    DATA_SOURCE = PSDataLake
  , FILE_FORMAT = CSVFileFormat  
  , LOCATION='/TaxiZones/'    
  , REJECT_TYPE = VALUE
  , REJECT_VALUE = 1
  , REJECTED_ROW_LOCATION='/Errors/TaxiZones'
)
GO

SELECT * FROM ext.TaxiZones

































