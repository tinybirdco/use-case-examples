# Tinybird Versions - Add Column to a Materialized View

Adding a new column to a Materialized View Data Source is a delicate process that needs to be handled with care to ensure data integrity and continuity. This guide will take you through the steps to achieve this without stopping your data ingestion.

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps
This change needs to re-create the Materialized View and populate it again with all the data without stoping our ingestion.

For that the steps will be:

1. Change the Materialized View (Pipe and Data Source) to add the new column.
2. Bump the major version, in our case from 1.0.0 -> 2.0.0. Bumping the major version, it will create a new `Preview Release` internally forking the Materialized View and its dependencies.
3. Backfill the `Preview Release` Materialized View with the data previous to its creation.
4. Promote the release from `Preview` to `Live`.

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/209/files)

## 1: Change the Materialized View

- Change the Materialized View: Pipe and Datasource

`analytics_sessions_mv.datasource`:
```diff
SCHEMA >
    `date` Date,
    `session_id` String,
+    `version` SimpleAggregateFunction(any, String),
    `device` SimpleAggregateFunction(any, String),
    `browser` SimpleAggregateFunction(any, String),
    `location` SimpleAggregateFunction(any, String),
    `first_hit` SimpleAggregateFunction(min, DateTime),
    `latest_hit` SimpleAggregateFunction(max, DateTime),
    `hits` AggregateFunction(count)
ENGINE "AggregatingMergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(date)"
ENGINE_SORTING_KEY "date, session_id"
```

`analytics_sessions.pipe`
```diff
SELECT
        toDate(timestamp) AS date,
        session_id,
+       anySimpleState(version) AS version,
        anySimpleState(device) AS device,
        anySimpleState(browser) AS browser,
        anySimpleState(location) AS location,
        minSimpleState(timestamp) AS first_hit,
        maxSimpleState(timestamp) AS latest_hit,
        countState() AS hits
    FROM analytics_hits
    GROUP BY
        date,
        session_id
```

## 2: Bump version
- Bump to the next version `2.0.0` in the `.tinyenv` file. It will **re-create** the Materialized View and all its downstream in a new `Preview Release`. 

`.tinyenv`
  ```diff
-   VERSION=1.0.0
+   VERSION=2.0.0
  ```

## 3: Skip regression tests
- As we are re-creating a Materialized View, it will be empty (or just with the fixture data) in the CI testing step. For that reason the regression tests will fail. Add `--skip-regresion-tests` label to the Pull Request to bypass them.


## 3: Backfilling 

Once you have deployed the previous changes and they are ready in a `Preview Release` you can opt to backfill the data previous to the Materialized View re-creation.

Remember that in the Preview Release we're ingesting the production data, but `analytics_sessions_mv` lacks the rows prior to its recent creation.

> As we lack a timestamp in the Data Source, we are utilizing its creation date to backfill all the information preceding its creation. Please note that this mechanism is not entirely accurate and may generate some duplicates in case there is lag in your ingestion. If your Data Source has a timestamp that can serve as a reference for the backfilling, please check [here]([add_nullable_column_to_landing_data_source](https://github.com/tinybirdco/use-case-examples/tree/main/change_sorting_key_landing_data_source)) how to use it.

- Get the creation date by executing the following command
```sh
tb --semver 2.0.0 datasource ls
```
or executing this query using the CLI or the UI dashboard

```sh
tb --semver 2.0.0 sql "select timestamp from tinybird.datasources_ops_log where event_type = 'create' and datasource_name = 'analytics_sessions_mv' order by timestamp desc limit 1"
```

- Use the creation date to populate the Materialized View with the data previous to its creation. You can run the next command:
```sh
tb --semver 2.0.0 pipe populate analytics_sessions --node analytics_sessions_1 --sql-condition "timestamp < '$CREATED_AT' --wait
```

## 4: Promote the changes
Once the Materialized View has been already populated you can promote the `Preview Release` to `Live`. Choose one of the next 3 options for that:
- If you are using our workflow templates just run the action `Tinybird - Releaseas Workflow` in other case you can use the command:
  
- Run the following command from the CLI:
  
```sh
  tb release promote --semver 2.0.0
```
- Or go to the `Releases` section in the UI and promote the `Preview 2.0.0`
