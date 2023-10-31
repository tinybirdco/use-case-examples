# Delete simple resource

Delete simple Data Sources or Pipes easily. Create a Pull Request following these steps:

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

- Create a new branch
- Remove the Pipes or Data Sources
- Update the `.tinyenv` file with a new version
- Create the deploy files for the CI and CD with the commands for removing those resources. You need to place them in a folder named with the same `.tinyenv` version. Pay attention to the commands used in the example, where we skip the confirmation, if not the job won't finish
- Give the right permissions to the `.sh` files, if not the job will fail
- Push your changes

Go to your Workspace and check the new Environment created. These changes will be displayed:

![Changes in environment](./images/delete-resources.png)

> For the moment, you need to specify the commands for the CI and CD, but in future versions it won't be needed


[Internal workspace](https://ui.tinybird.co/128be410-8de1-4b1c-805c-145fdcf2566a/dashboard)