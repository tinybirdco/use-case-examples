# Add a new column to a BigQuery Data Source

### 1st Create a BigQuery Data Source 

[Pull Request #1](https://github.com/tinybirdco/use-case-examples/pull/269)

- Create a new branch
- Create a new BigQuery connection `tb connection create bigquery` 
- Generate the new BigQuery Data Source schema ([instructions](https://www.tinybird.co/docs/ingest/bigquery.html))
- Commit and wait for CI. You can check in the temporary CI branch that everything works as expected.
- Merge and wait for CD.

### 2nd BigQuery Data Source with the new column

[Pull Request #2](https://github.com/tinybirdco/use-case-examples/pull/270)

- Create another branch
- Add the new column to the schema and query
- Commit and wait for CI. You can check in the temporary CI branch that everything works as expected.
- Merge and wait for CD.
- [Optionally] Run `tb datasource sync bq_pypi_data` to force sync and populate the new column.

[Internal workspace](https://app.tinybird.co/gcp/europe-west3/55bd1979-6638-434d-9049-324112188f32/dashboard)
