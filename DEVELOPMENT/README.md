# Set up a new practice Workspace

This allows you to follow any of the use case tutorials in a safe place away from your active or Production Workspace.

1. [Create a new Workspace](https://www.tinybird.co/docs/quick-start#your-first-workspace) in Tinybird using the UI and choose the `Web Analytics` Template. This generates a new Workspace and includes all the resources from the Web Analytics template
2. Create a repository in Github (private or public)
3. [Connect the Workspace with the repository](https://www.tinybird.co/docs/version-control/working-with-version-control#connect-your-workspace-to-git-from-the-ui) using the UI. Follow the steps and push all the changes to the repo
4. At this point, you should have a Workspace connected to Git and using the release 0.0.0
5. (Optional) Use [`mockingbird`](https://mockingbird.tinybird.co/) to stream fake data to your new Workspace
6. (Optional) Run the script `utils/query_api.sh` to generate fake requests to the Workspace's API Endpoints
