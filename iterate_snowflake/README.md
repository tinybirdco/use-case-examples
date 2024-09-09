# Use cases for iteration of Snowflake Data Sources

First of all, you must connect your Tinybird workspace with your Git repository using the [documentation about versions](https://www.tinybird.co/docs/production/working-with-version-control#connect-your-workspace-to-git-from-the-cli) 

### Create a Snowflake Data Source 

- Create the Snowflake Connection in your main tinybird workspace using Tinybird CLI, as explain in the [iteration documentation](https://www.tinybird.co/docs/ingest/snowflake). Snowflake connections reside always in the main branch.
- Create a new git branch 
- Create a new Snowflake .datasource data file in the branch, as in the example PR. You shouldn't need fixtures as the Data Source will be populated from the connection, but you can add fixtures and/or tests if needed.
  - For information abount Snowflake options read the [connector documentation](https://www.tinybird.co/docs/ingest/snowflake)
- Commit an create a new PR/MR from the branch to `main`
- Wait for CI. You can check in the temporary workspace branch (automatically created and named like `tmp_ci_*`) that everything works as expected.
- Merge and wait for CD. Now you should have your Data Source in the main workspace, using the connection, and the temporary CI branch will be deleted.

[Example Pull Request](https://github.com/tinybirdco/use-case-examples/pull/tbd)


### Update Snowflake Data Source with a new column, with same connection

- Create another git branch
- Add the new column to the schema and query
- Commit and create an ew PR from the branch to `main`
- Wait for CI to finish. You can check in the temporary workspace branch (automatically created and named like `tmp_ci_*`) that everything works as expected.
- Merge and wait for CD. Now you should have your Data Source updated in the main workspace, using the connection, and the temporary CI branch will be deleted.

[Example Pull Request](https://github.com/tinybirdco/use-case-examples/pull/tbd)

### 4th Delete a Snowflake Data Source

- Create another git branch
- Remove the .datasource data file
- Commit and create an ew PR from the branch to `main`
- Wait for CI to finish. You can check in the temporary workspace branch (automatically created and named like `tmp_ci_*`) that everything works as expected.
- Merge and wait for CD. Now you should have your Data Source updated in the main workspace, using the connection, and the temporary CI branch will be deleted.

