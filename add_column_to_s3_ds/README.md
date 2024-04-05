# Add a new column to an S3 Data Source

Adding a column to an Amazon S3 Data Source is a straightforward and commonly-executed task in any data project.

> Remember to follow the [instructions](../README.md) to set up a fresh Tinybird Workspace to practice this tutorial

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/50)

Let's say you want to introduce a new column named `environment`, which will temporarily accept either NULL (for compatibility), 'staging' or 'production' as its values. The `LowCardinality<String>` type would be ideal, but there is a challenge: currently, messages being processed lack the `environment` attribute. Until all data producers update their systems to include this new property, you need to accommodate NULL values. 

Steps:

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

- As good practice, update your tests:
  - New quality test to ensure that all the values for environment are null, 'staging' or 'production':
  
    ```sql
        SELECT * FROM analytics_events
        WHERE environment is not null 
            AND environment != 'staging'
            AND environment != 'production'
    ```
  - Fixtures updated with the new property to test that continue being successfully ingested
 
- Create a PR, validate your changes in the created temporary environment, and merge it to deploy it in the main environment
