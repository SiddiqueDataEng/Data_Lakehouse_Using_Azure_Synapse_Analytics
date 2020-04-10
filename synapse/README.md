Azure Synapse Analytics – Lakehouse Demo

This repository contains Synapse artifacts and assets aligned to the course modules. It organizes linked services, datasets, pipelines, SQL scripts, and notebooks for a real-world lakehouse scenario (NYC taxis).

Structure
- linkedService/ – connection definitions
- dataset/ – input/output dataset schemas
- pipeline/ – orchestration pipelines
- sql/ – SQL scripts (references to course files)
- notebook/ – Spark notebooks (references to course files)

Deploy
1) Import into Synapse Studio (Manage → Git configuration) or publish via ARM/CI.
2) Update secrets in linked services before running.


