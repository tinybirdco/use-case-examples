# Tinybird Versions - Use case examples

## Before starting

Either you want to reproduce a use case or create a new one, please follow the [instructions](DEVELOPMENT/README.md) in the DEVELOPMENT readme.

> If there is any use case referencing any other Data Project, it will be documented in the README of the use case.


## Use cases

This repository contains all the use cases you can iterate with Versions:

- [Delete simple resource](delete_simple_resource)
- [Change Data Source sorting key](change_sorting_key)
- [Recover data from quarantine](recover_data_from_quarantine) using a copy Pipe
- [Add a new column to a Landing Data Source](add_column_landing_ds)
- [Add a new column to a Materialized View](add_column_materialized_view)
- [Add a new column in a BigQuery Data Source](add_column_BQ_ds)
- [Add a new column to an S3 Data Source](add_column_to_s3_ds)
- [Change column type from String to LowCardinality(String)](change_column_type_to_lowcardinality)

## Caveats

Unfortunately, GitHub doesn't allow running workflows in different subfolders so it isn't possible to include the CI and CD workflow files in the same use case folder. Every CI/CD action is located in `.github/workflows` and has the same folder name as the use case.
