# Add a new column to a Snowflake Data Source

These are the steps to add a new column to a Snowflake Data Source.

> Remember to follow the [instructions](../README.md) to set up a fresh Tinybird Workspace to practice this tutorial

### 1. Create your Snowflake Data Source

[Pull Request #1](https://github.com/tinybirdco/use-case-examples/pull/73)

- Create a new branch
- Create a new Snowflake connection `tb connection create snowflake`
- Generate the new Snowflake Data Source schema ([instructions](https://www.tinybird.co/docs/ingest/snowflake.html))
- Push your changes

### 2. Add column to the Snowflake Data Source

[Pull Request #2](https://github.com/tinybirdco/use-case-examples/pull/74)

- Create another branch
- Modify the Data Source schema to include the new column
- Generate a new CI/CD version with `tb release generate --semver 0.0.2`
- In the CI/CD script files, include the `--yes` flag to confirm that you want to alter the Data Source.
- Push your changes
- [Optionally] Run `tb datasource sync stock_prices` to force sync and populate the new column
