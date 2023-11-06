# Tinybird Versions - Use case examples

## Before starting

It is necessary a Tinybird Data Project, with Versions enabled, and connected to Git before starting. By default, the [web-analytics-starter-kit](https://github.com/tinybirdco/web-analytics-starter-kit) Data Project will be used. The steps to follow:

1. Create a Workspace with the starter kit or download it from the [original repository](https://github.com/tinybirdco/web-analytics-starter-kit/tree/main/tinybird) and push the resources to any empty Workspace
2. Follow the [documentation](https://www.tinybird.co/docs/guides/working-with-git.html) for connecting your Tinybird Data Project to Git
3. Read the use case and follow the instructions there

If there is any use case referencing any other Data Project, it will be documented in the use case README.


## Use cases

This repository contains all the use cases you can iterate with Versions:

- [Delete simple resource](delete_simple_resource)
- [Change Data Source sorting key](change_sorting_key)
- [Recover data from quarantine](recover_data_from_quarantine) using a copy Pipe
- [Add a new column to a Landing Data Source](add_column_landing_ds)
- [Add a new column in a BigQuery Data Source](add_column_BQ_ds)

## Caveats

Unfortunately, GitHub doesn't allow running workflows in different subfolders so it isn't possible to include the CI and CD workflow files in the same use case folder. Every CI/CD action is located in `.github/workflows` and has the same folder name as the use case.
