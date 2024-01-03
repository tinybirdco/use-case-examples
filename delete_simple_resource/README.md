# Delete simple resource
> Important! Resources Deletion has been improved and it's much easier using Releases: [Delete simple resource using Releases](v3/delete_simple_resource) 

Delete simple Data Sources or Pipes easily. Create a [Pull Request](https://github.com/tinybirdco/use-case-examples/pull/5) following these steps:

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

- Create a new branch
- Remove the Pipes or Data Sources
- Generate a new CI/CD version `tb release generate --semver 0.0.1`
- Include your delete operations in both CI/CD files
- Push your changes

Go to your Workspace and check the new Environment created. These changes will be displayed:

![Changes in environment](./images/delete-resources.png)

> For the moment, you need to specify the commands for the CI and CD, but in future versions it won't be needed


[Internal workspace](https://ui.tinybird.co/128be410-8de1-4b1c-805c-145fdcf2566a/dashboard)