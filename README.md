# Tinybird Versions - Use case examples

## Before starting

It is necessary a Tinybird Data Project, with Versions enabled, and connected to Git before starting. By default, the [web-analytics-starter-kit](https://github.com/tinybirdco/web-analytics-starter-kit) Data Project will be used. The steps to follow:

1. Create a Workspace with the starter kit or download it from the [original repository](https://github.com/tinybirdco/web-analytics-starter-kit/tree/main/tinybird) and push the resources to any empty Workspace
2. Follow the [documentation](https://www.tinybird.co/docs/guides/working-with-git.html) for connecting your Tinybird Data Project to Git
3. Read the use-case and follow the instructions there

If there is any use-case referencing any other Data Project, it will be documented it in the use-case README.


## Use cases

This repository contains all the use cases you can iterate with Versions:

- Add column
  - Landing
  - Materialized
  - Materialized with downstream
- Remove column
  - Landing
  - Materialized
  - Materialized with downstream
- Change column type
  - Compatible type (e.g. String to LowCardinality(String))
  - Incompatible type (e.g. String to DateTime)
  - Landing
  - Materialized
  - Materialized with downstream
- Change Data Source sorting key
- Create new resources
  - Pipe
  - Data Source
  - Materialized View
- Delete resources
  - Pipe
  - Data Source
  - Materialized View
- Change Data Source settings: TTL, partition key, sorting key
  - Landing
  - Materialized
  - Materialized with downstream
- Change Pipe Endpoint
- Change Pipe Endpoint with downstream
- Depending Materialized Views
  - Multiple cases
- Kafka Data Source
  - With Null Engine
  - With MergeTree
- Connectors
  - BigQuery
  - Snowflake
  - S3
  - GCS
- HFI
- Data Operations
  - When there's a connector
  - When there's HFI
  - When there's Kafka
  - others?
- Tokens
- [Recovering rows from quarantine with CI/CD](https://www.tinybird.co/docs/guides/quarantine.html#recovering-rows-from-quarantine-with-ci-cd)


## Caveats

Unfortunately, GitHub doesn't allow running workflows in different subfolders so it isn't possible to include the CI and CD workflow files in the same use-case folder. Every CI/CD action is located in `.github/workflows` and the same folder name as the use-case.