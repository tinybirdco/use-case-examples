# Tinybird Versions - Use case examples

## Before starting

Either you want to reproduce a use case or create a new one, please follow the [instructions](DEVELOPMENT/README.md) in the DEVELOPMENT readme.

> If there is any use case referencing any other Data Project, it will be documented in the README of the use case.

## Use cases

This repository contains all the use cases you can iterate with Versions:

- [Delete simple resource](delete_simple_resource)
- [Change Data Source sorting key](change_sorting_key)
- [Change S3 Data Source sorting key](change_sorting_key_to_s3_data_source)
- [Change S3 Data Source sorting key with reingestion](change_sorting_key_to_s3_data_source_with_reingestion)
- [Change Kafka Data Source sorting key](change_sorting_key_to_kafka_data_source)
- [Recover data from quarantine](recover_data_from_quarantine) using a copy Pipe
- [Add a new column to a Landing Data Source](add_column_landing_ds)
- [Add a new column to a Materialized View](add_column_materialized_view)
- [Add a new column in a BigQuery Data Source](add_column_BQ_ds)
- [Add a new column to a Snowflake Data Source](add_column_snowflake_ds)
- [Add a new column to an S3 Data Source](add_column_to_s3_ds)
- [Add a new column to a Kafka Data Source](add_column_kafka_ds)
- [Change a Data Source's TTL](change_ttl)
- [Change column type from String to LowCardinality](change_column_type_to_lowcardinality)
- [Remove Column from a Materialized View](delete_column_materialized_view)
- [Remove Column from a Snowflake Data Source](delete_column_snowflake_ds)
- [Change Copy pipe and its target Data Source](change_copy_pipe)
- [Use shared Data Source](use_new_columns_from_shared_datasource)

## Caveats

Unfortunately, GitHub doesn't allow running workflows in different subfolders so it isn't possible to include the CI and CD workflow files in the same use case folder. Every CI/CD action is located in `.github/workflows` and has the same folder name as the use case.
