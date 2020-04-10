/**************************************************************************************
  Create schema for Dimensions and Facts
**************************************************************************************/

CREATE SCHEMA dim;
GO

CREATE SCHEMA fact;
GO


/**************************************************************************************
  View for Rate Codes
**************************************************************************************/

CREATE VIEW dim.RateCodes 
AS
SELECT *
FROM
    OPENROWSET(
        BULK 'https://pstaxisdatalake.dfs.core.windows.net/taxioutput/Dimensions/RateCodes.parquet',
        FORMAT='PARQUET'
    ) AS rateCodes
GO

/**************************************************************************************
  View for Taxi Zones
**************************************************************************************/

CREATE VIEW dim.TaxiZones
AS
SELECT *
FROM
    OPENROWSET(
        BULK 'https://pstaxisdatalake.dfs.core.windows.net/taxioutput/Dimensions/TaxiZones.parquet',
        FORMAT='PARQUET'
    ) AS taxiZones
GO

/**************************************************************************************
  View for Yellow Taxis
**************************************************************************************/

CREATE VIEW fact.YellowTaxis
AS
SELECT *
FROM
    OPENROWSET(
        BULK 'https://pstaxisdatalake.dfs.core.windows.net/taxioutput/Facts/YellowTaxis.parquet',
        FORMAT='PARQUET'
    ) AS yellowTaxis
GO

/**************************************************************************************
  View for Green Taxis
**************************************************************************************/

CREATE VIEW fact.GreenTaxis
AS
SELECT *
FROM
    OPENROWSET(
        BULK 'https://pstaxisdatalake.dfs.core.windows.net/taxioutput/Facts/GreenTaxis.parquet',
        FORMAT='PARQUET'
    ) AS greenTaxis
GO























