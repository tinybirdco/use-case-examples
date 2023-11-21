# Delete column from a Snowflake Data Source

These are the minimal steps to delete an existing column from a Snowflake Data Source:

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

### 1st Snowflake Data Source

[Pull Request #1](https://github.com/tinybirdco/use-case-examples/pull/73)

- Create a new branch
- Create a new Snowflake connection `tb connection create snowflake`
- Generate the new Snowflake Data Source schema ([instructions](https://www.tinybird.co/docs/ingest/snowflake.html))
- Push your changes
-

### 2nd New Snowflake Data Source without the column

[Pull Request #2](https://github.com/tinybirdco/use-case-examples/pull/74)

- Create another branch
- Create a new Data Source with the same connnection and remove the column
- Create a copy Pipe to move the data from the old Data Source to the new one
- Generate a new CI/CD version with `tb release generate --semver 0.0.2`
- In the CI/CD script files, apart from the deploy command, include `tb pipe copy run stock_prices_old_to_new` to run the copy Pipe
- Push your changes

[Internal workspace](https://ui.tinybird.co/47b16c48-4aa3-4dbc-a4f9-941cdb8011e7/dashboard)
