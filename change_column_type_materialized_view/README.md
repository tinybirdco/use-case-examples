# Tinybird Versions - Change column from String to LowCardinality(String)

This update aims at optimizing the storage and query performance of the `analytics_pages_mv` datasource. The change is the conversion of the `browser` column from a `String` type to a `LowCardinality(String)` type. 

To change a column type in a Materialized View Data Source is a process that needs to be handled with care to ensure data integrity and continuity. This guide will take you through the steps to achieve this without stopping your data ingestion.

This change needs to re-create the Materialized View and populate it again with all the data without stoping our ingestion.

For that, the steps will be:

1. Create a new Materialized View (Pipe and Data Source) to change the type to the column.
2. Run CI.
3. Backfill the new Materialized View with the data previous to its creation.
4. Run CD and run the backfill in the main Workspace.
5. Connect the endpoints to the new Materialized View.

## 1: Create the new the Materialized View

- Create the new Materialized View: Pipe and Datasource

`analytics_pages_mv_1.datasource`:
```diff
 SCHEMA >
     `date` Date,
     `device` String,
-    `browser` String,
+    `browser` LowCardinality(String),
     `location` String,
     `pathname` String,
     `visits` AggregateFunction(uniq, String),
```

`analytics_pages_1.pipe`
```diff
     SELECT
         toDate(timestamp) AS date,
         device,
-        browser,
+        toLowCardinality(browser) as browser,
         location,
         pathname,
         uniqState(session_id) AS visits,
```

Create a Copy Pipe `analytics_pages_backfill.pipe` for backfilling purposes:

```
NODE analytics_pages_backfill_node

SQL >
    %
    SELECT
        toDate(timestamp) AS date,
        device,
        toLowCardinality(browser) as browser,        
        location,
        pathname,
        uniqState(session_id) AS visits,
        countState() AS hits
    FROM analytics_hits
    WHERE timestamp BETWEEN {{DateTime(start_backfill_timestamp)}} AND {{DateTime(end_backfill_timestamp)}}
    GROUP BY
        date,
        device,
        browser,
        location,
        pathname

TYPE COPY
TARGET_DATASOURCE analytics_pages_mv_1
```

## 2: Run CI

Make sure the changes are deployed correctly in the CI Tinybird Branch. Optionally you can add automated tests or verify it from the `tmp_ci_*` Branch created as part of the CI pipeline.

## 3: (For large datasets) Splitting the Data into Chunks for Backfilling

If your data source is large, you may run into a memory error like this:
```
error: "There was a problem while copying data: [Error] Memory limit (for query) exceeded. Make sure the query just process the required data. Contact us at support@tinybird.co for help or read this SQL tip: https://tinybird.co/docs/guides/best-practices-for-faster-sql.html#memory-limit-reached-title"
```

To avoid memory issues, you will need to break the backfill operation into smaller, manageable chunks. This approach reduces the memory load per query by processing only a subset of the data at a time. You can use the ***data source's sorting key*** to define each chunk.
Refer to [this guide](https://www.tinybird.co/docs/work-with-data/strategies/backfill-strategies#scenario-3-streaming-ingestion-with-incremental-timestamp-column) for more details.

## 4: Backfilling 

Wait for the first event to be ingested into `analytics_pages_mv_1` and then proceed with the backfilling.

- Get the creation date by executing the following command
```sh
tb datasource ls
```
or executing this query using the CLI or the UI dashboard

```sh
tb sql "select timestamp from tinybird.datasources_ops_log where event_type = 'create' and datasource_name = 'analytics_pages_mv_1' order by timestamp desc limit 1"
```

- Use the creation date to backfill with the data previous to its creation:
```sh
tb pipe copy run analytics_pages_backfill --node analytics_pages_backfill_node --param start_backfill_timestamp='2024-01-01 00:00:00' --param end_backfill_timestamp='$CREATED_AT' --wait --yes
```

## 5: Run CD

Merge the PR and make sure to run the backfilling operation over the main Workspace

## 6: Connect the downstream dependencies

Once the new Materialized View is created and synchronized you can create another Pull Request to start using it in your endpoints.
