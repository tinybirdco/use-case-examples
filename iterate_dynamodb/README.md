# Use cases for iteration of DynamoDB Data Sources

First of all, you must connect your Tinybird Workspace with your Git repository using the [documentation about Versions](https://www.tinybird.co/docs/production/working-with-version-control#connect-your-workspace-to-git-from-the-cli) 

### Create a DynamoDB Data Source 

- Create the DynamoDB Connection in your main Tinybird Workspace using Tinybird CLI, as explained in the [iteration section](https://www.tinybird.co/docs/ingest/dynamodb). Connections reside always in the main Tinybird Branch.
- Create a new git branch 
- Create a new DynamoDB .datasource Datafile in the git branch, as in the example PR. You can use fixtures and tests as the Data Source won't be populated from the Connection.
  - For information about DynamoDB options and recommendations read the [connector documentation](https://www.tinybird.co/docs/ingest/dynamodb)
- Commit your code and create a new PR/MR from the branch to `main` 
- Wait for CI to finish.
- Check that everything is created as expected in the temporary Tinybird Branch, CI will automatically create it and name it like `tmp_ci_{PRid}`).
- You can travel to this Branch through UI and check that the Data Source is created and Schema is correct.
- If everything is fine, merge and wait for CD. Now you should have your Data Source in the main Workspace, using the Connection, and the temporary CI Branch will be deleted.

[Example Pull Request](https://github.com/tinybirdco/use-case-examples/pull/364)


### Update DynamoDB Data Source with a new column, with same Connection

- Create another git branch
- Add the new column to the schema and query in the Datafile
- Commit your code and create a new PR from the branch to `main`
- Wait for CI to finish.
- Check that everything is updated as expected in the temporary branch, CI will automatically create it and name it like `tmp_ci_{PRid}`).
- Merge and wait for CD. Now you should have your Data Source updated in the main Workspace, using the Connection, and the temporary CI Branch will be deleted.

[Example Pull Request](https://github.com/tinybirdco/use-case-examples/pull/365)

### Delete a DynamoDB Data Source

- Create another git branch
- Remove the .datasource Datafile
  - If the Data Source has dependencies they must be deleted too, to the workflow to work
- Commit your code and create a new PR from the branch to `main`
- Wait for CI to finish.
- Check that the Data Source has been deleted in the temporary Branch, CI will automatically create it and name it like `tmp_ci_{PRid}`).
- Merge and wait for CD. Now you should have your Data Source deleted in the main Workspace, and the temporary CI Branch will be deleted.
- If the Connection isn't being used by any other Data Sources, you can remove it directly using CLI.

