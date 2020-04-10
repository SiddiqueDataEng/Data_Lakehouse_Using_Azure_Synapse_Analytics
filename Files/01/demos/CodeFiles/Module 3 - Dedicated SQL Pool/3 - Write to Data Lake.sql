CREATE EXTERNAL TABLE ext.ProcessedYellowTaxis
WITH 
(  
    DATA_SOURCE = PSDataLake,
    FILE_FORMAT = SynapseParquetFormat,
    LOCATION='/Facts/YellowTaxis.parquet'    
) 
AS
SELECT 
      PickupTime        = tpep_pickup_datetime
    , DropTime          = tpep_dropoff_datetime
    , Passengers        = passenger_count
    , TripDistance      = trip_distance
    , RateCodeId        = RatecodeID
    , PickupLocationId  = PULocationID
    , DropLocationId    = DOLocationID
    , PaymentTypeId     = payment_type
    , TotalAmount       = total_amount    
FROM main.YellowTaxis y
    INNER JOIN ext.TaxiZones z ON y.PULocationID = z.LocationID
WHERE tpep_pickup_datetime >= '2019-11-01' 
    AND tpep_pickup_datetime < '2019-12-01'
    AND passenger_count > 0
	AND z.ServiceZone = 'Yellow Zone';