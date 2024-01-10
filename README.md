# Tinybird Versions - Use case examples

## Before starting

Either you want to reproduce a use case or create a new one, please follow the [instructions](DEVELOPMENT/README.md) in the DEVELOPMENT readme.

> If there is any use case referencing any other Data Project, it will be documented in the README of the use case.

## Use cases

This repository contains all the use cases you can iterate with Versions:

- [Add a column to a Landing Data Source](add_nullable_column_to_landing_data_source)
- [Delete simple resource](delete_simple_resource)
- [Recover data from quarantine](recover_data_from_quarantine)
- [Remove column from landing Data Source](remove_column_landing_data_source)

## Caveats

Unfortunately, GitHub doesn't allow running workflows in different subfolders so it isn't possible to include the CI and CD workflow files in the same use case folder. Every CI/CD action is located in `.github/workflows` and has the same folder name as the use case.
