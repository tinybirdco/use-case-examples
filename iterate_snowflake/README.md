# Use cases for iteration of Snowflake Data Sources

First of all, you must connect your Tinybird workspace with your Git repository using the [documentation about versions](https://www.tinybird.co/docs/production/working-with-version-control#connect-your-workspace-to-git-from-the-cli) 

### Create a Snowflake Data Source 

- Create the Snowflake Connection in your main tinybird workspace using Tinybird CLI, as explain in the [iteration documentation](https://www.tinybird.co/docs/ingest/snowflake). Snowflake connections reside always in the main branch.
- Create a new git branch 
- Create a new Snowflake .datasource data file in the branch, as in the example PR. You shouldn't need fixtures as the Data Source will be populated from the connection, but you can add fixtures and/or tests if needed.
  - For information about Snowflake options read the [connector documentation](https://www.tinybird.co/docs/ingest/snowflake)
- Commit your code and create a new PR/MR from the branch to `main` 
- Wait for CI to finish.
- Check that everything is working as expected in the temporary branch, CI will automatically create it and name it like `tmp_ci_{PRid}`).
- Merge and wait for CD. Now you should have your Data Source in the main workspace, using the connection, and the temporary CI branch will be deleted.

[Example Pull Request](https://github.com/tinybirdco/use-case-examples/pull/359)


### Update Snowflake Data Source with a new column, with same connection

- Create another git branch
- Add the new column to the schema and query
- Commit your code and create an ew PR from the branch to `main`
- Wait for CI to finish.
- Check that everything is working as expected in the temporary branch, CI will automatically create it and name it like `tmp_ci_{PRid}`).
- Merge and wait for CD. Now you should have your Data Source updated in the main workspace, using the connection, and the temporary CI branch will be deleted.

[Example Pull Request](https://github.com/tinybirdco/use-case-examples/pull/360)

### Delete a Snowflake Data Source

- Create another git branch
- Remove the .datasource data file
- Commit your code and create an ew PR from the branch to `main`
- Wait for CI to finish.
- Check that everything is working as expected in the temporary branch, CI will automatically create it and name it like `tmp_ci_{PRid}`).
- Merge and wait for CD. Now you should have your Data Source updated in the main workspace, using the connection, and the temporary CI branch will be deleted.

