# Tinybird Versions - Add Column to a Materialized View

For that the steps will be:

1. Create a new Materialized View (Pipe and Data Source) to add the new column.
2. Backfill
3. Connect endpoints to the new Data Source
4. Delete old Pipe and Data Source

## 1: Create a new Materialized View

[PR](https://github.com/tinybirdco/use-case-examples/pull/286)

`analytics_sessions_mv1.datasource`:
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

`analytics_sessions1.pipe`
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
    WHERE timestamp > '2024-05-27 11:00:00'
    GROUP BY
        date,
        session_id
```

Note we are filtering by a date in the future to be able to perform a backfill operation.

Additionally we create a Pipe only for backfilling purposes, see `analytics_sessions1_backfill.pipe` in the [PR](https://github.com/tinybirdco/use-case-examples/pull/286)

## 2: Backfill

While this can be automated using a custom deployment that runs the backfill operation we recommend it to just do it manually. So once the previous PR has been merged and the backfill DateTime (in this case '2024-05-27 11:00:00') has passed, you can run this command on your main Workspace:

`tb pipe populate analytics_sessions1_backfill --node analytics_sessions_1_1_backfill --wait`

Additionally you can run some query with `tb sql` over both Data Sources to check for data quality.

## 3: Connect endpoints to the new Data Source

Once you've validated data quality on both Data Sources, you can make the Pipe endpoints to use the new `analytics_sessions_1` Data Source.

[See PR](https://github.com/tinybirdco/use-case-examples/pull/287)

## 3: Delete old Pipe and Data Source 

Once the changes are in the main Workspace and running in production you can get rid of old resources by just using `git rm`, create a git branch and merge it.

[See PR](https://github.com/tinybirdco/use-case-examples/pull/288)
