# Tinybird Versions - Add Column to a Materialized View Data Source

> This document is still an early draft, when it's ready this message will be removed.

Link to all the PRs for this example [TODO]

Introducing a new column to a Materialized View Data Source is a delicate process that needs to be handled with care to ensure data integrity and continuity. This guide will take you through the steps to achieve this without disrupting your data flow.

> A Materialized View Data Source in Tinybird is an optimized data source that pre-aggregates data from a base Data Source using Pipes. It's crucial for ensuring fast data retrieval.

Follow these steps to add a new column safely and efficiently.

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

## Step 1: Prepare a Duplicate Materialized View with New Column
Our goal is to add a new `environment` column to the `analytics_sessions_mv`` Materialized View Data Source. We'll create a duplicate of this Data Source to include the new column without affecting the current data stream.

- Create a new branch in your repository.
- Duplicate analytics_sessions_mv.datasource and add the new column to the schema:
    ```sql
        SCHEMA >
            `timestamp` DateTime `json:$.timestamp`,
            `session_id` String `json:$.session_id`,
            `action` LowCardinality(String) `json:$.action`,
            `version` LowCardinality(String) `json:$.version`,
            `environment` String `json:$.environment`, -- New column
            `payload` String `json:$.payload`
    ```
- Define a filter to prevent duplication by synchronizing data streams after a specific point in time:
  ```sql
  WHERE timestamp > 'YYYY-MM-DD HH:MM:SS'
  ```
- Create a Pull Request, validate the changes in the temporal environment created, and merge it to deploy to the main environment.

[Step 1 PR TODO]

## Step 2: Backfill the Data
After the filter date has passed, it's time to backfill the data from the original to the new Data Source. This is critical to ensure consistency across your Data Sources.

- Execute the backfill operation by only including data previous to the filter date:
```
WHERE timestamp <= 'YYYY-MM-DD HH:MM:SS'
```
- Create a custom deployment to populate the new Data Source using the `backfilling.pipe``:
- Submit a new Pull Request for the backfilling step.

[Step 2 PR TODO]

## Step 3: Transition to the New Materialized View

Finally, update all dependent elements, such as API endpoints, to use the new Materialized View with the added column.

- Modify the dependencies to point to the new Data Source `new_analytics_sessions_mv`.
- Validate that the transition is seamless and that the new Materialized View is returning the correct data. 
- Once confirmed, merge the changes to the main environment.

... work in progress ...