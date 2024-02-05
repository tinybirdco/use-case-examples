# Tinybird Versions - Add Column to a Landing Data Source with Specific Values

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

> Add a new column to a Data Source when you don't need specific values for the new column in the existing rows it's much more straightforward process: [Add Column to a Landing Data Source](../add_nullable_column_to_landing_data_source)

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/242/files)


1. Add the column to the Data Source

```diff
SCHEMA >
    `timestamp` DateTime `json:$.timestamp`,
    `session_id` String `json:$.session_id`,
    `action` LowCardinality(String) `json:$.action`,
    `version` LowCardinality(String) `json:$.version`,
+   `environment` String `json:$.environment`,
    `payload` String `json:$.payload`
```

2. Bump the SemVer major version to re-create the Data Source in a Preview Release where we can populate the desired values in the new column. [More information about Deployment Strategies]().
   
```diff
- 0.0.1
+ 1.0.0
```

3. Prepare the backfill resources by filling the new column with the desired default value. Learn more about [backfill strategies when there's a timestamp](https://versions.tinybird.co/docs/version-control/backfill-strategies.html#scenario-3-streaming-ingestion-with-incremental-timestamp-column) available and follow the example to backfill the data. 
Before promoting your changes from `Preview` to `Live` make sure all your data producers are sending data in the `environment` column. Otherwise, they will be sent to the Quarantine Data Source.

> As we're creating a new empty `analytics_events` Data Source the regression tests will fail so you need to bypass them by adding the tag `--skip-regression-tests` to the PR.

`backfill_data.pipe`

```diff
+ NODE node
+ SQL >
+    %
+    SELECT *, 'production' AS environment
+    FROM v0_0_1.analytics_events
+    WHERE timestamp BETWEEN {{DateTime(start_backfill_timestamp)}} AND {{DateTime(end_backfill_timestamp)}} 
+ TYPE COPY
+ TARGET_DATASOURCE analytics_events
```

`sync_data.pipe`

```diff
+ NODE node
+ SQL >
+    SELECT *, 'production' AS environment
+    FROM v0_0_1.analytics_events
+    WHERE timestamp > '2024-02-05 17:00:00'
+ TYPE materialized
+ DATASOURCE analytics_events
```








