/**************************************************************************************
  View for FHV Bases
**************************************************************************************/

CREATE VIEW dim.FHVBases
AS
    SELECT TOP (100) [BaseLicenseId]
        ,[BaseType]
        ,[AddressBuilding]
        ,[AddressStreet]
        ,[AddressCity]
        ,[AddressState]
        ,[AddressPostalCode]
    FROM [fhvwarehouse].[dbo].[fhvbases]
GO


/**************************************************************************************
  View for FHV Trips
**************************************************************************************/

CREATE VIEW fact.FHVTrips
AS
    SELECT [CompanyLicenseId]
        ,[BaseLicenseId]
        ,[PickupTime]
        ,[DropTime]
        ,[PickupLocationId]
        ,[DropLocationId]
        ,[TripYear]
        ,[TripMonth]
        ,[TripDay]
    FROM [fhvwarehouse].[dbo].[fhvtrips]
GO





















