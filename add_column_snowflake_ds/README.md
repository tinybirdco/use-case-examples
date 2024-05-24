# Add a new column to a Snowflake Data Source

### 1st Create a Snowflake Data Source 

[Pull Request #1](https://github.com/tinybirdco/use-case-examples/pull/277)

- Create a new branch
- Create a new Snowflake Data Source ([instructions](https://www.tinybird.co/docs/ingest/snowflake))
- Commit and wait for CI. You can check in the temporary CI branch that everything works as expected.
- Merge and wait for CD.

### 2nd Snowflake Data Source with the new column

[Pull Request #2](https://github.com/tinybirdco/use-case-examples/pull/278)

- Create another branch
- Add the new column to the schema and query
- Commit and wait for CI. You can check in the temporary CI branch that everything works as expected.
- Merge and wait for CD.
- [Optionally] Run `tb datasource sync stock_prices` to force sync and populate the new column.

[Internal workspace](https://app.tinybird.co/gcp/europe-west3/5792cd20-de4d-42cc-838f-b9748e07a34d/dashboard)
