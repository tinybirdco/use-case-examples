# How to create a new "Use case" example

1. Create a new workspace in Tinybird using the UI and choose to use the `Web Analytics` Template. This will generate a new Workspace and push all the resources from the Web Analytics template
2. Create a repository in Github (private or public)
3. Connect the workspace with the repository using the UI. Follow the steps and push all the changes to the repo
4. At this point, you should have a workspace connected to Git and using the release 0.0.0
5. (Optional) You can use `mockingbird` to start fake data to our workspace. Just go to https://mockingbird.tinybird.co/ and follow the steps to start sending data to your workspace
6. (Optional) You can run the script `utils/query_api.sh` to generate fake requests to the endpoints of the workspace