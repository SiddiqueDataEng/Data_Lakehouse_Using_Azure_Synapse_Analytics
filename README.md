## Data Lakehouse Using Azure Synapse Analytics – Real-World Project

This project demonstrates a complete lakehouse on Azure Synapse Analytics using NYC Taxi data. It covers ingesting raw data into a data lake, transforming it with Spark, persisting curated data, and serving analytics via Dedicated and Serverless SQL.

### What’s included
- synapse/: Synapse artifacts
  - linkedService/: connections to ADLS Gen2 and Synapse SQL
  - dataset/: dataset definitions (CSV, JSON, Parquet)
  - pipeline/: orchestration pipeline
  - notebook/index.json: references to Spark notebooks provided in Files/
  - sql/index.json: references to SQL scripts provided in Files/
- Files/: Sample data and course scripts used by the artifacts (very large files excluded)

### Architecture overview
- Lakehouse layers
  - Bronze (Raw): TaxiZones CSV, FHV bases JSON, YellowTaxis Parquet in ADLS Gen2
  - Silver (Refined): Cleaned/typed datasets persisted as Parquet/Delta via Spark
  - Gold (Serving): Data mart via Dedicated SQL and Serverless external tables/views
- Engines
  - Synapse Spark for data prep and curation
  - Dedicated SQL for warehouse-style tables and performance tests
  - Serverless SQL for ad-hoc, pay-per-query analytics

### Data footprint (samples)
- Files/01/demos/DataFiles/DataLakeFiles/TaxiZones/TaxiZones1.csv, TaxiZones2.csv
- Files/01/demos/DataFiles/DataLakeFiles/FhvBases.json
- Yellow Taxis (Parquet): store in your ADLS and update dataset paths accordingly (large sample excluded from repo)

### Synapse artifacts
- Linked services
  - ls_AzureDataLake (`synapse/linkedService/ls_adls.json`)
    - Type: AzureBlobFS (ADLS Gen2)
    - Update `properties.typeProperties.url` to your ADLS account
  - ls_SynapseSqlDedicated (`synapse/linkedService/ls_sql_dedicated.json`)
    - Type: AzureSqlDW
    - Update connection string with your workspace and dedicated pool name
  - ls_SynapseSqlServerless (`synapse/linkedService/ls_sql_serverless.json`)
    - Type: AzureSqlDatabase (serverless endpoint)
    - Update server to `<workspace>-ondemand.sql.azuresynapse.net`

- Datasets
  - ds_TaxiZonesCsv (`synapse/dataset/ds_taxi_zones_csv.json`): CSV folder for TaxiZones
  - ds_FhvBasesJson (`synapse/dataset/ds_fhv_bases_json.json`): JSON file for FHV bases
  - ds_YellowTaxisParquet (`synapse/dataset/ds_yellow_taxis_parquet.json`): Parquet sample (point to your ADLS path)

- Notebooks (referenced via `synapse/notebook/index.json`)
  - 1 - Exploration Notebook.ipynb: explore data and schema inference
  - 2 - Process FHV Data - Development.ipynb: clean, transform, and write curated data
  - 3 - Read from Dedicated SQL Pool.ipynb: cross-engine access demonstration
  - 1- Query CosmosDB.ipynb, 3- Write to CosmosDB.ipynb: optional connected services
  - Import these notebooks into Synapse Studio to run them

- SQL scripts (referenced via `synapse/sql/index.json`)
  - Module 3 (Dedicated SQL Pool): external tables, COPY, distribution strategies, and perf comparison
  - Module 5 (Pipelines): stored procedures for loading TaxiZones/YellowTaxis
  - Module 6 (Serverless SQL): queries over CSV/Parquet, external table creation, data mart views
  - Module 7 (Connected Servers): Serverless query over Cosmos DB

- Pipeline
  - `pl_IngestTransformPublish` (`synapse/pipeline/pl_ingest_transform_publish.json`)
    - Copy TaxiZones CSV to staging
    - Execute Spark notebook to process FHV data
    - Call SQL stored procedure to load curated tables (ensure proc exists in dedicated pool)

### Environment setup
1) Provision a Synapse workspace, Spark pool, and a Dedicated SQL pool (optional for warehouse features)
2) Create an ADLS Gen2 account and filesystem for data (update dataset paths accordingly)
3) In Synapse Studio → Manage → Linked services: create connections matching the JSON definitions (or import/publish these artifacts and then update parameters)
4) Upload sample data to your ADLS paths used by datasets

### Running the solution
1) Import notebooks referenced in `synapse/notebook/index.json` into your Spark pool
2) Execute the notebook that processes FHV data and writes curated outputs
3) Run SQL scripts from `synapse/sql/index.json` in the appropriate contexts:
   - Dedicated SQL: external tables, COPY into warehouse tables, distribution tests
   - Serverless SQL: quick queries and external tables/views on lake data
4) Orchestrate end-to-end with pipeline `pl_IngestTransformPublish`

### Data model (suggested gold layer)
- Dimensions: `DimTaxiZones`, `DimFhvBases`
- Facts: `FactYellowTaxis`, `FactFhvTrips`
- Consider partitioning facts by month and clustering on pickup location/time keys

### Performance and cost guidance
- Choose appropriate distribution (HASH/ROUND_ROBIN/REPLICATE) for Dedicated SQL tables
- Use COPY for parallel loads and partition large datasets in the lake
- Use Serverless SQL for ad-hoc queries; limit scanned data with file/path predicates
- Pause the Dedicated SQL pool when idle

### Security and governance
- Prefer Managed Identity and/or Azure Key Vault for secrets
- Use RBAC on ADLS folders/containers for least privilege
- Capture pipeline run logs/alerts and Spark job metrics for observability

### Known limitations
- Large binaries (e.g., sample Parquet) are not stored in the repo. Place them in your ADLS account and update dataset locations.
- The `index.json` files act as pointers; import the referenced notebooks/scripts into Synapse Studio before execution.
