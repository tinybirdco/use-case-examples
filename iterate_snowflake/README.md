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
  - Move to the test branch and try to sync the new Data Source:
```commandline
tb auth
tb branch use tmp_ci_{id}
tb datasource sync {data_source_name} --yes
``` 
For Snowflake Data Sources, the scheduler services must be provisioned before the first sync. This can take a while and you'll receive an error during this time:
```commandline
tb datasource sync {data_source_name} --yes
Error:
** Failed syncing Data Source {data_source_name}: The service is being provisioned. It might take a while, please retry in a few seconds.
```
- You can travel to the branch through UI and check that the Data Source is working (also you'll need to wait until the service is provisioned).
- If everything is fine, merge and wait for CD. Now you should have your Data Source in the main workspace, using the connection, and the temporary CI branch will be deleted.

[Example Pull Request](https://github.com/tinybirdco/use-case-examples/pull/359)


### Update Snowflake Data Source with a new column, with same connection

- Create another git branch
- Add the new column to the schema and query
- Commit your code and create an new PR from the branch to `main`
- Wait for CI to finish.
- Check that everything is working as expected in the temporary branch, CI will automatically create it and name it like `tmp_ci_{PRid}`).
  - You can travel to the branch through UI and check that the Data Source has the changes and is working (you'll need to wait until the service is provisioned).
- Merge and wait for CD. Now you should have your Data Source updated in the main workspace, using the connection, and the temporary CI branch will be deleted.

[Example Pull Request](https://github.com/tinybirdco/use-case-examples/pull/360)

### Delete a Snowflake Data Source

- Create another git branch
- Remove the .datasource data file
  - If the Data Source has dependencies they must be deleted too, to the workflow to work
- Commit your code and create a new PR from the branch to `main`
- Wait for CI to finish.
- Check that everything is working as expected in the temporary branch, CI will automatically create it and name it like `tmp_ci_{PRid}`).
- Merge and wait for CD. Now you should have your Data Source updated in the main workspace, using the connection, and the temporary CI branch will be deleted.
- If the connection isn't being used by any other Data Sources, you can remove it directly using CLI.

