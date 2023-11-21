# Add a new column to a Snowflake Data Source

These are the minimal steps to add a new column to a Snowflake Data Source:

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

### 1st Snowflake Data Source

[Pull Request #1](https://github.com/tinybirdco/use-case-examples/pull/73)

- Create a new branch
- Create a new Snowflake connection `tb connection create snowflake`
- Generate the new Snowflake Data Source schema ([instructions](https://www.tinybird.co/docs/ingest/snowflake.html))
- Push your changes

[Internal workspace](https://ui.tinybird.co/7ba1463e-b0df-4c5f-bd3d-0927e142d596/dashboard)

### 2nd Add column to the Snowflake Data Source

[Pull Request #2](https://github.com/tinybirdco/use-case-examples/pull/74)

- Create another branch
- Modify the Data Source schema to include the new column
- Generate a new CI/CD version with `tb release generate --semver 0.0.2`
- In the CI/CD script files, include the `--yes` flag to confirm that you want to alter the Data Source.
- Push your changes
- [Optionally] Run `tb datasource sync stock_prices` to force sync and populate the new column

[Internal workspace](https://ui.tinybird.co/55bd1979-6638-434d-9049-324112188f32/dashboard)
