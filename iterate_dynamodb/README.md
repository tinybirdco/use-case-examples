# Use cases for iteration of DynamoDB Data Sources

First of all, you must connect your Tinybird workspace with your Git repository using the [documentation about versions](https://www.tinybird.co/docs/production/working-with-version-control#connect-your-workspace-to-git-from-the-cli) 

### Create a DynamoDB Data Source 

- Create the DynamoDB Connection in your main tinybird workspace using Tinybird CLI, as explain in the [iteration documentation](https://www.tinybird.co/docs/ingest/dynamodb). Connections reside always in the main branch.
- Create a new git branch 
- Create a new DynamoDB .datasource data file in the branch, as in the example PR. You shouldn't need fixtures as the Data Source will be populated from the connection, but you can add fixtures and/or tests if needed.
  - For information about DynamoDB options read the [connector documentation](https://www.tinybird.co/docs/ingest/dynamodb)
- Commit your code and create a new PR/MR from the branch to `main` 
- Wait for CI to finish.
- Check that everything is working as expected in the temporary branch, CI will automatically create it and name it like `tmp_ci_{PRid}`).
- You can travel to the branch through UI and check that the Data Source is working
  - You'll need wait for the initial synchronization job to end, check the job status in the dashboard and the logs in the Data Source `log` tab
  - You can add/update/delete items in your DynamoDB table and check that the changes reproduce in the Data Source.
- If everything is fine, merge and wait for CD. Now you should have your Data Source in the main workspace, using the connection, and the temporary CI branch will be deleted.

[Example Pull Request](https://github.com/tinybirdco/use-case-examples/pull/)


### Update DynamoDB Data Source with a new column, with same connection

- Create another git branch
- Add the new column to the schema and query
- Commit your code and create a new PR from the branch to `main`
- Wait for CI to finish.
- Check that everything is working as expected in the temporary branch, CI will automatically create it and name it like `tmp_ci_{PRid}`).
  - You can travel to the branch through UI and check that the Data Source has the changes applied
  - You can add/update/delete items in your DynamoDB table and check that the changes reproduce in the Data Source.
- Merge and wait for CD. Now you should have your Data Source updated in the main workspace, using the connection, and the temporary CI branch will be deleted.

[Example Pull Request](https://github.com/tinybirdco/use-case-examples/pull/)

### Delete a DynamoDB Data Source

- Create another git branch
- Remove the .datasource data file
  - If the Data Source has dependencies they must be deleted too, to the workflow to work
- Commit your code and create a new PR from the branch to `main`
- Wait for CI to finish.
- Check that everything is working as expected in the temporary branch, CI will automatically create it and name it like `tmp_ci_{PRid}`).
- Merge and wait for CD. Now you should have your Data Source deleted in the main workspace, using the connection, and the temporary CI branch will be deleted.
- If the connection isn't being used by any other Data Sources, you can remove it directly using CLI.

