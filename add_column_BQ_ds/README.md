# Add a new column to a BigQuery Data Source

It isn't possible to add a new column to a BigQuery Data Source in one iteration. but we'll create a new one with the new column and populate it with the old data using a copy Pipe. The steps are:

> Remember to follow the [instructions](../README.md) to set up a fresh Tinybird Workspace to practice this tutorial

### 1. Create your 1st BigQuery Data Source 

[Pull Request #1](https://github.com/tinybirdco/use-case-examples/pull/15)

- Create a new branch
- Create a new BigQuery connection `tb connection create bigquery` 
- Generate the new BigQuery Data Source schema ([instructions](https://www.tinybird.co/docs/ingest/bigquery.html))
- Push your changes

### 2. Create your 2nd BigQuery Data Source with the new column

[Pull Request #2](https://github.com/tinybirdco/use-case-examples/pull/71)

- Create another branch
- Create a new and final BigQuery Data Source, but this time with the new column (in this case `country_code`)
- With a Copy Pipe, the old data will be copied into the new Data Source
- Generate a new CI/CD version `tb release generate --semver 0.0.4`
- In the CI/CD script files, as you are altering an existing Data Source, include the `--yes` flag
- Push your changes
- [Optional] Run `tb datasource sync bq_pypi_data` to force sync and populate the new column
