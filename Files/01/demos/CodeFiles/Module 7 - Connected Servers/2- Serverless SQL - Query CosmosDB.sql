CREATE CREDENTIAL [pltaxiscosmosdb]
WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'mjuS6UKXLyxJbclfX4l90z66ak4sk1eUxzuUwKnIVwUbs2i7l8sAykFDfWJ1GeC7CplwwSw6VbnzgdRxHJbxlQ=='
GO

SELECT TOP 100 
      RideId
    , PickupLocationId
    , Rating
    , Feedback
FROM OPENROWSET(​PROVIDER = 'CosmosDB',
                CONNECTION = 'Account=pltaxicosmosdb;Database=RidesDB',
                OBJECT = 'RidesFeedback',
                SERVER_CREDENTIAL = 'pltaxiscosmosdb'
) AS [RidesFeedback]




