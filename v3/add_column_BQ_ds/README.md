# Add a new column to a BigQuery Data Source

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

### 1st BigQuery Data Source 

[Pull Request #1](https://github.com/tinybirdco/use-case-examples/pull/15)

- Create a new branch
- Create a new BigQuery connection `tb connection create bigquery` 
- Generate the new BigQuery Data Source schema ([instructions](https://www.tinybird.co/docs/ingest/bigquery.html))
- Push your changes

### 2nd BigQuery Data Source with the new column

[Pull Request #2](https://github.com/tinybirdco/use-case-examples/pull/71)

- Create another branch
- Create a new (and the last) BigQuery Data Source, but this time with the new column. In our case it is `country_code`
- With a copy Pipe, the old data will be copied into the new Data Source
- Generate a new CI/CD version `tb release generate --semver 0.0.4`
- In the CI/CD script files, since we are altering an existing Data Source, include the `--yes` flag.
- Push your changes
- [Optionally] Run `tb datasource sync bq_pypi_data` to force sync and populate the new column.


[Internal workspace](https://ui.tinybird.co/55bd1979-6638-434d-9049-324112188f32/dashboard)