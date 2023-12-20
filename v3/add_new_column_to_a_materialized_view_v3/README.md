# Tinybird Versions - Add Column to a Materialized View using Releases

Introducing a new column to a Materialized View Data Source is a delicate process that needs to be handled with care to ensure data integrity and continuity. This guide will take you through the steps to achieve this without disrupting your data flow.

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

This change needs to re-create the Materialized View and populate it again with all the data without stoping our ingestion.

For that the steps will be:

(In this Pull Request)
1. Change the Materialized View (Pipe and Data Source) to add the new column.
2. Bump version from 0.0.0 -> 0.0.1. It will create a new Preview Release internally forking the Materialized View and its dependencies.

(Out of this Pull Request)
3. Backfill the Preview Release Materialized View with the data previous to its creation.
4. Promote the release from Preview to Live.

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
+   WHERE timestamp > '2023-12-20 10:00:00'
    GROUP BY
        date,
        session_id
```


> As you can see, we added a filter to prevent duplication by synchronizing data streams after a specific point in time in future:
  ```sql
  WHERE timestamp > 'YYYY-MM-DD HH:MM:SS'
  ```
  In a further step, we'll backfill the data previous to that date.

## 2: Bump version
- Bump to the next version `0.0.1` .tinyenv it will re-create the Materialized View and all its downstream in a Preview Release. 

`.tinyenv`
  ```sh
    VERSION=0.0.1
  ```

Please note that in this Preview Release we're ingesting the production data, but lacks the rows prior to the filter date we previously established. Once we reach that filter date in time, we can then proceed with the backfilling process first and then to promote the release to production.

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/141/files)
