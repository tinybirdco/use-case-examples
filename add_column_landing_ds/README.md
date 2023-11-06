# Tinybird Versions - Add Column to a Landing Data Source

Link to all the PRs for this example [ACDS PRs](https://github.com/tinybirdco/use-case-examples/pulls?q=is%3Apr+ACDS)

Adding a column to a Landing Data Source is a straightforward and commonly executed task in any Data Project. It allows for the consumption of new data, but it’s important to be aware that the moment in which columns are added is significant.

> A Landing Data Source is the initial data repository that collects information from multiple channels enabled by Tinybird for data ingestion. It serves as the first point of entry for new data, where it is gathered before undergoing any subsequent processing or transformation.

In this guide we'll show you how to do it fast and safe.

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

## Step 1: Initialize a Nullable Column for 'environment'
We aim to introduce a new column named environment, which will temporarily accept either 'staging' or 'production' as its values. The `LowCardinality<String>` type would be ideal, but we face a challenge: we are currently processing messages that lack the 'environment' attribute. Until all data producers update their systems to include this new property, we need to accommodate NULL values. Therefore, we will initially establish a `Nullable<String>` column, which we'll later convert once we ensure every message includes the `environment` field:

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

- Crate a PR, validate your changes in the temporal created environment and merge it to deploy in the main environment.

[Step 1 PR](https://github.com/tinybirdco/use-case-examples/pull/33)

## Step 2: Transition to a Non-Nullable Column and Data Migration
Once it's confirmed that all incoming messages consistently contain the environment field, and the absence of this field is consider an error, it's time to alter the column type and start the data migration process.

... work in progress ...