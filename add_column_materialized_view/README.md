# Tinybird Versions - Add Column to a Materialized View Data Source

> This document is still an early draft, when it's ready this message will be removed.

Introducing a new column to a Materialized View Data Source is a delicate process that needs to be handled with care to ensure data integrity and continuity. This guide will take you through the steps to achieve this without disrupting your data flow.

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

## Step 1: Prepare a Duplicate Materialized View with New Column

[PR Step 1](https://github.com/tinybirdco/use-case-examples/pull/35)

Our goal is to add a new `environment` column to the `analytics_sessions_mv` Materialized View Data Source. We'll create a duplicate of this Data Source to include the new column without affecting the current data stream.

- Create a new branch in your repository.
- Duplicate analytics_sessions_mv.datasource and add the new column to the schema:
  
    ```sql
    SCHEMA >
      `date` Date,
      `session_id` String,
      `environment` SimpleAggregateFunction(any, String), -- new column
      `device` SimpleAggregateFunction(any, String),
      `browser` SimpleAggregateFunction(any, String),
      `location` SimpleAggregateFunction(any, String),
      `first_hit` SimpleAggregateFunction(min, DateTime),
      `latest_hit` SimpleAggregateFunction(max, DateTime),
      `hits` AggregateFunction(count)
    ```
- In addition, We need to duplicate the Pipe that materializes data in the previous Data Source

  ```sql
      SELECT
        toDate(timestamp) AS date,
        session_id,
        anySimpleState(environment) AS environment, -- new column
        anySimpleState(device) AS device,
        anySimpleState(browser) AS browser,
        anySimpleState(location) AS location,
        minSimpleState(timestamp) AS first_hit,
        maxSimpleState(timestamp) AS latest_hit,
        countState() AS hits
      FROM analytics_hits
      WHERE timestamp > '2023-11-07 12:30:00'
      GROUP BY
          date,
          session_id

      TYPE materialized
      DATASOURCE new_analytics_sessions_mv
  ```
  
- As you can see, we added a filter to prevent duplication by synchronizing data streams after a specific point in time:
  ```sql
  WHERE timestamp > 'YYYY-MM-DD HH:MM:SS'
  ```
- Create a Pull Request, validate the changes in the temporal environment created, and merge it to deploy to the main environment.

## Step 2: Backfill the Data

[PR Step 2](https://github.com/tinybirdco/use-case-examples/pull/37)

After the filter date has passed, it's time to backfill the data from the original to the new Data Source. This is critical to ensure consistency across your Data Sources.

- Execute the backfill operation by only including data previous to the filter date, for that create a new pipe `backfilling.pipe`:

```sql
    SELECT
        toDate(timestamp) AS date,
        session_id,
        anySimpleState(environment) AS environment,
        anySimpleState(device) AS device,
        anySimpleState(browser) AS browser,
        anySimpleState(location) AS location,
        minSimpleState(timestamp) AS first_hit,
        maxSimpleState(timestamp) AS latest_hit,
        countState() AS hits
    FROM analytics_hits
    WHERE timestamp <= '2023-11-07 12:30:00' -- Filter date to avoid duplicates
    GROUP BY
        date,
        session_id

TYPE materialized
DATASOURCE new_analytics_sessions_mv
```

- Create a custom deployment to populate the new Data Source using the `backfilling.pipe`:
  
  ```sh
    tb release --semver 0.0.1
  ```

  It creates a folder `./deploy/0.0.1` with custom deployment files.

  - The custom CI command located in `./deploy/0.0.1/ci-deploy.sh` will look like:
  ```sh
    tb deploy --populate --fixtures --wait
  ```
  `populate` ensures that the new pipe runs and materializes data in the new Materialized View Data Source.
  `wait` ensures that the CI Workflows waits until all the data is populated.
  `fixtures` appends the fixtures for the tests.

  - Modify the CD custom command `./deploy/0.0.1/cd-deploy.sh` to be the same but without the fixtures options because we don't want to pollute the production environment with testing data:

  ```sh
    tb deploy --populate --wait
  ```

- Add a quality test to check that the backfilling is working as expected before going to production. We can compare the difference of number of hits in the new and legacy Data Sources (it shouldn't be any difference):

  ```sql
        WITH
        (SELECT countMerge(hits) FROM analytics_sessions_mv) AS legacy_hits,
        (SELECT countMerge(hits) FROM analytics_sessions) AS new_hits
      SELECT
        legacy_hits - new_hits AS diff
      WHERE
        diff != 0 -- Quality tests expect that no rows are returned.
  ```
- Submit a new Pull Request for the backfilling step, check the temporal environment created to make sure everything is OK and merge it once all the PR checks are met.

## Step 3: Transition to the New Materialized View

Finally, following your requirements, update all dependent elements, such as API endpoints, to use the new Materialized View with the added column.

- Modify the dependencies to point to the new Data Source `new_analytics_sessions_mv`.
- Validate that the transition is seamless and that the new Materialized View is returning the correct data. 
- Once confirmed, merge the changes to deploy the changes in the main environment.
