-- Run query on Round Robin distributed table
SELECT [PULocationID]
	, DATENAME(WEEKDAY, tpep_pickup_datetime)
	, AVG(
			DATEDIFF(SECOND, tpep_pickup_datetime, tpep_dropoff_datetime)
		 )
FROM main.YellowTaxis_RoundRobin
GROUP BY [PULocationID]
	, DATENAME(WEEKDAY, tpep_pickup_datetime)



-- Run query on Hash distributed table
SELECT [PULocationID]
	, DATENAME(WEEKDAY, tpep_pickup_datetime)
	, AVG(
			DATEDIFF(SECOND, tpep_pickup_datetime, tpep_dropoff_datetime)
		 )
FROM main.YellowTaxis_Hash
GROUP BY [PULocationID]
	, DATENAME(WEEKDAY, tpep_pickup_datetime)
