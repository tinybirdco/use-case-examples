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

### 3rd Explicitly add `insertion_date` to a Data Source schema

For a while, we added the `insertion_date` column to Data Sources with all Nullable columns. We did this to provide an efficient [sorting key](https://www.tinybird.co/clickhouse/knowledge-base/sorting-key-performance) for those Data Sources. This, however, has created many problems when iterating Data Sources. We have stopped adding this column and are now explicitly adding it to the schema for those Data Sources that already have it.


To keep your `main` branch in sync with this, you can follow these steps:
1. Create a new branch
2. Execute `tb pull --force` with a CLI version >= 5.0.0.
3. Commit and merge the changes.

[Pull Request #3](TODO)