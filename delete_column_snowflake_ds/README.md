# Delete column from a Snowflake Data Source

These are the minimal steps to delete an existing column from a Snowflake Data Source:

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

### 1st Snowflake Data Source

[Pull Request #1](https://github.com/tinybirdco/use-case-examples/pull/277)

- Create a new branch
- Create a new Snowflake Data Source ([instructions](https://www.tinybird.co/docs/ingest/snowflake))
- Commit and wait for CI. You can check in the temporary CI branch that everything works as expected.
- Merge and wait for CD.

### 2nd New Snowflake Data Source without the column

- Create another branch
- Create a new Data Source `stock_prices_1.datasource` with the same connnection and remove the column from the `schema` and `import_query`
- Create a copy Pipe `stock_prices_old_to_new` to move the data from the old Data Source to the new one

```
NODE backfill_node
SQL >
    select * from stock_prices

TYPE COPY
TARGET_DATASOURCE stock_prices_1
```

- Run the backfill `tb pipe copy run stock_prices_old_to_new --wait --yes` or `tb datasource sync` to sync from Snowflake. You can run it manually or as part of a custom deployment. You can validate the copy job is working in CI.
- Merge and wait for CD.
- Run the backfill `tb pipe copy run stock_prices_old_to_new --wait --yes` or `tb datasource sync` to sync from Snowflake in the main Workspace.
