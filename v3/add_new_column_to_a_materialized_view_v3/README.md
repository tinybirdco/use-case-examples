# Tinybird Versions - Add Column to a Materialized View using Releases

Introducing a new column to a Materialized View Data Source is a delicate process that needs to be handled with care to ensure data integrity and continuity. This guide will take you through the steps to achieve this without disrupting your data flow.

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

This change needs to re-create the Materialized View and populate it again with all the data without stoping our ingestion.

For that the steps will be:

1. Change the Materialized View (Pipe and Data Source) to add the new column.
2. Bump version from 0.0.0 -> 0.0.1. It will create a new Preview Release internally forking the Materialized View and its dependencies.
3. Backfill the Preview Release Materialized View with the data previous to its creation.
4. Promote the release from Preview to Live.

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/141/files)

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
- Bump to the next version `0.1.0` in the `.tinyenv` file. It will **re-create** the Materialized View and all its downstream in a new `Preview Release`. 

`.tinyenv`
  ```diff
-   VERSION=0.0.1
+   VERSION=0.1.0
  ```

Please note that in this Preview Release we're ingesting the production data, but `analytics_sessions_mv` lacks the rows prior to its recent creation. We show how to backfill it in the next step.

## 3: Backfilling 
Once you have deploy the previous changes and are ready in a Preview Release you need to backfill the data previous to the Materialized View re-creation.

- Get the creation date by executing the following command
```sh
tb --semver 0.1.0 datasource ls
```
or

```sh
tb --semver 0.0.1 sql "select timestamp from tinybird.datasources_ops_log where event_type = 'create' limit 1"
```

- Use the creation date to populate the Materialized View with the data previous to its creation.
```sh
tb --semver 0.0.1 pipe populate analytics_sessions --node analytics_sessions_1 --sql-condition "timestamp < '$CREATED_AT' --wait
```

## 4: Promote the changes
Once the Materialized View has been already populated you can promote the `Preview Release`. If you are using our workflow templates just run the action `Tinybird - Releaseas Workflow` in other case you can use the command:

```sh
tb release promote --semver 0.1.0
```


