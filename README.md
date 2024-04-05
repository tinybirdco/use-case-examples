# Tinybird version control: Examples of iteration use cases

This repository contains individual examples of "iterating an aspect of your Tinybird Workspace using version control". You can either simply read through these use cases, or make a new practice Workspace and follow them as step-by-step tutorials. They are designed to give you a safe learning space, so you can understand the process of making the changes you need in your own active Workspace.

## Before you begin

To make a new Workspace and get yourself set up for any of the tutorials, follow the setup instructions in the [DEVELOPMENT README](DEVELOPMENT/README.md). Then, pick an example (see the list below) and follow its README.

## What's in the box?

Each use case tutorial is stored in an individual subfolder and contains all the Workspace resources you'll need: Data Sources, Pipes, API Endpoints, and more.

> Be aware that GitHub doesn't allow running workflows in different subfolders, so it isn't possible to include the CI and CD workflow files in the same use case folder. Every CI/CD action is located in `.github/workflows` and has the same folder name as the use case.

## Use cases

- [Add column to a Materialized View](add_new_column_to_a_materialized_view)
- [Add column to a Landing Data Source](add_nullable_column_to_landing_data_source)
- [Add column with values to a Landing Data Source](add_new_column_with_values)
- [Add column to a Kafka Data Source](add_column_kafka_data_source)
- [Change column type in a Materialized View](change_column_type_materialized_view)
- [Change Copy Pipe time granularity](change_copy_pipe_time_granularity)
- [Change sorting key to a Landing Data Source](change_sorting_key_landing_data_source)
- [Change sorting key to a Kafka connected Data Source](change_sorting_key_kafka_data_source)
- [Change TTL to a Data Source](change_data_source_ttl)
- [Create a Pipe Sink to S3](create_pipe_sink)
- [Create a Materialized View with batch ingest](create_a_materialized_view_batch_ingest)
- [Delete simple resource](delete_simple_resource)
- [Iterating an API Endpoint](iterating_api_endpoint)
- [How to Rollback](how_to_rollback)
- [Recover data from quarantine](recover_data_from_quarantine)
- [Remove column from landing Data Source](remove_column_landing_data_source)
- [Use new columns from a Shared Data Source](use_new_columns_from_shared_datasource)

## Help and feedback

Found a typo or feeling stuck on something? Open an issue on this PR or contact us in the [Tinybird Slack Community](https://www.tinybird.co/docs/community).


TBC
> If there is any use case referencing any other Data Project, it will be documented in the README of the use case.
