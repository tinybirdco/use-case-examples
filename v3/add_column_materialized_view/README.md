# Tinybird Versions - Add Column to a Materialized View using Releases

Introducing a new column to a Materialized View Data Source is a delicate process that needs to be handled with care to ensure data integrity and continuity. This guide will take you through the steps to achieve this without disrupting your data flow.

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

This change needs to re-create the Materialized View and populate it again with all the data without stoping our ingestion.

For that the steps will be:

1. Change the Materialized View (Pipe and Data Source) to add the new column, using the `--fork-downstream` to re-create the Materialized View and the dependant resources.
2. Create a Preview Release with the changes done.
3. Backfill the Preview Release with the data missing.
4. Promote the release from Preview to Live.

## Step 1 and 2: Change the Materialized View and create a Preview Release

[Pull Request #1] (https://github.com/tinybirdco/use-case-examples/pull/113/files)

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
+        anySimpleState(version) AS version,
        anySimpleState(device) AS device,
        anySimpleState(browser) AS browser,
        anySimpleState(location) AS location,
        minSimpleState(timestamp) AS first_hit,
        maxSimpleState(timestamp) AS latest_hit,
        countState() AS hits
    FROM analytics_hits
    WHERE timestamp > '2023-12-14 11:45:00'
    GROUP BY
        date,
        session_id
```

> As you can see, we added a filter to prevent duplication by synchronizing data streams after a specific point in time in future:
  ```sql
  WHERE timestamp > 'YYYY-MM-DD HH:MM:SS'
  ```
  In a further step, we'll backfill the data previous to that date.

- Bump to the next version `0.0.1` .tinyenv, and add the deployment scripts deploying with `--fork-downstream` to re-create the Materialized View and all its downstream. 
  In the CD deployment we'll create a Preview Release with this changes but we're not promoting to `live` yet.

  ```sh
    tb release create --semver ${VERSION}
    tb --semver ${VERSION} deploy --fork-downstream
    tb release preview --semver ${VERSION}
  ```

Please note that in this Preview Release we're ingesting the production data, but lacks the rows prior to the filter date we previously established. Once we reach that filter date in time, we can then proceed with the backfilling process.

## Step 3

[Pull Request #2] (https://github.com/tinybirdco/use-case-examples/pull/114/files)

- Create the the `backfilling.pipe` to move all the data previous to the filter date.

- Bump a new version in the `.tinyenv` to execute new custom deployment scripts. 

- Add the `backfilling.pipe` to the version we have in preview (0.0.1) and deploy with `--populate` option.

Once the Preview Release has all the data you can promote it to `live`. (TODO: Add how to promote it)