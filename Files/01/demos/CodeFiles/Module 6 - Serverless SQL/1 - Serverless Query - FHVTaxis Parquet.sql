SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://pstaxisdatalake.dfs.core.windows.net/taxioutput/Facts/FhvTaxis.parquet/TripYear=2019/TripMonth=11/TripDay=1/part-00000-bf814e8a-6a0a-4e9b-80a9-6884ba3137ef.c000.snappy.parquet',
        FORMAT='PARQUET'
    ) AS fhv







SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://pstaxisdatalake.dfs.core.windows.net/taxioutput/Facts/FhvTaxis.parquet/**',
        FORMAT='PARQUET'
    ) AS fhv






SELECT TOP 100 
      FileLocation = fhv.filepath()
    , FileName = fhv.filename()
    , *
FROM
    OPENROWSET(
        BULK 'https://pstaxisdatalake.dfs.core.windows.net/taxioutput/Facts/FhvTaxis.parquet/**',
        FORMAT='PARQUET'
    ) AS fhv




SELECT TOP 100 
      TripYear = fhv.filepath(1)
    , TripMonth = fhv.filepath(2)
    , TriDay = fhv.filepath(3)
    , *
FROM
    OPENROWSET(
        BULK 'https://pstaxisdatalake.dfs.core.windows.net/taxioutput/Facts/FhvTaxis.parquet/TripYear=*/TripMonth=*/TripDay=*/**',
        FORMAT='PARQUET'
    ) AS fhv
WHERE fhv.filepath(3) = '1'



























































