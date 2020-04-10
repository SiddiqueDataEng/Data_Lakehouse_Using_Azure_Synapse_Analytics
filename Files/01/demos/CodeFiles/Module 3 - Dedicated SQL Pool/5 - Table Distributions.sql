-- Create Round Robin table for Yellow Taxis
CREATE TABLE main.YellowTaxis_RoundRobin
WITH
(
    DISTRIBUTION = ROUND_ROBIN
)
AS
SELECT * 
FROM ext.YellowTaxis

-- Check distribution of data
DBCC PDW_SHOWSPACEUSED('main.YellowTaxis_RoundRobin')

-- Create Hash table for Yellow Taxis, based on PULocationID
CREATE TABLE main.YellowTaxis_Hash
WITH
(
    DISTRIBUTION = HASH(PULocationID)
)
AS
SELECT  *
FROM ext.YellowTaxis

-- Check distribution of data
DBCC PDW_SHOWSPACEUSED('main.YellowTaxis_Hash')























