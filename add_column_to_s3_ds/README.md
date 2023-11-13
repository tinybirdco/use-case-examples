# Tinybird Versions - Add Column to an S3 Data Source

Adding a column to an S3 Data Source is a straightforward and commonly executed task in any Data Project.

In this guide we'll show you how to do it fast and safe.

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

## Step 1: Initialize a Nullable Column for 'environment'

[Step 1 PR](https://github.com/tinybirdco/use-case-examples/pull/50)

We aim to introduce a new column named `environment`, which will temporarily accept either NULL (for compatibility), 'staging' or 'production' as its values. The `LowCardinality<String>` type would be ideal, but we face a challenge: we are currently processing messages that lack the `environment` attribute. Until all data producers update their systems to include this new property, we need to accommodate NULL values. 

- Establish a new branch
- Modify `analytics_events.datasource` to include the new column:
    ```sql
        SCHEMA >
            `timestamp` DateTime `json:$.timestamp`,
            `session_id` String `json:$.session_id`,
            `action` LowCardinality(String) `json:$.action`,
            `version` LowCardinality(String) `json:$.version`,
            `environment` Nullable(String) `json:$.environment`, -- New column
            `payload` String `json:$.payload`
    ```
- To apply the schema changes, execute a deployment using the `--yes` option. Generate a custom deployment script with:
  ```sh
    tb release generate --semver 0.0.1
  ```
  - Update the `cd-deploy.sh` and `ci-deploy.sh` scripts following the examples in the related PR.

- As a good practice we updated the tests
  - New quality test to ensure that all the values for environment are null, 'staging' or 'production':
  
    ```sql
        SELECT * FROM analytics_events
        WHERE environment is not null 
            AND environment != 'staging'
            AND environment != 'production'
    ```
  - Fixtures updated with the new property to test that continue being successfully ingested.
 
- Create a PR, validate your changes in the created temporal environment and merge it to deploy in the main environment.


