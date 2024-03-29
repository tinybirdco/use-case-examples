# Tinybird Versions - Add Column to a Landing Data Source with Specific Values

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

> Add a new column to a Data Source when you DON'T NEED specific values for the new column in the existing rows it's a much more straightforward process: [Add Column to a Landing Data Source](../add_nullable_column_to_landing_data_source)

[Pull Request of this use case](https://github.com/tinybirdco/use-case-examples/pull/242/files)

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

3. Prepare the backfill resources by filling the new column with the desired default value. Learn more about [backfill strategies when there's a timestamp](https://versions.tinybird.co/docs/version-control/backfill-strategies.html#scenario-3-streaming-ingestion-with-incremental-timestamp-column). Pay attention to the `sync_data.pipe` date filter, it has to be a date in the future, not reached before deploying to `Preview`. Create a PR with all your changes, wait until all the checks are OK and merge it.

> As we're creating a new empty `analytics_events` Data Source the regression tests will fail so you need to skip them by adding the tag `--skip-regression-tests` to the PR.

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
+    WHERE timestamp > '2024-02-05 17:10:00'
+ TYPE materialized
+ DATASOURCE analytics_events
```

4. Backfill data: After the deployment, you should have a Release in `Preview` state with version `1.0.0`. Wait until the future date filter (`2024-02-05 17:10:00` in this example) is reached. At this point, data should start to arrive in your re-created `analytics_events` Data Source:

```sh
tb --semver 1.0.0 sql "select count() as preview_rows from analytics_events"

----------------
| preview_rows |
----------------
|          110 |
----------------
```

but it is way lower than the `Live` version because only data after the future date filter has been synced:

```sh
tb sql "select count() as live_rows from analytics_events"

-------------
| live_rows |
-------------
|     13310 |
-------------
```

To fill that gap, It's time to run the copy pipe we prepared, to copy the Data before the future date filter that we have in the `live` version but not in the `preview 1.0.0` yet. For that, we run:

```sh
tb --semver 1.0.0 pipe copy run backfill_data --param start_backfill_timestamp='1970-01-01 00:00:00' --param end_backfill_timestamp='2024-01-05 17:10:00' --yes --wait
** Running backfill_data
** Copy to 'analytics_events' job created: https://api.tinybird.co/v0/jobs/1e195914-f3c1-4975-8350-9ddb844d0848
** Copying data   [████████████████████████████████████]  100%
** Data copied to 'analytics_events'
```

> Pay attention to the `--semver 1.0.0` to execute it in the Preview Release

Now we can easily check that both Data Sources have the same amount of rows by executing counts operations. If we have high-traffic ingestion we can add a filter with the current time to ensure we're not counting new rows added between the `select count()` executions:

```sh
tb sql "select count() as live_rows from analytics_events where timestamp < '2024-02-06 09:36:00'"

-------------
| live_rows |
-------------
|     13161 |
-------------
``````

```sh
tb sql --semver 1.0.0 "select count() as preview_rows from analytics_events where timestamp < '2024-02-06 09:36:00'"

----------------
| preview_rows |
----------------
|        13161 |
----------------
```

5. Everything is ready to promote the `Preview` Release to `Live`. Choose one of the next 3 options for that:

- If you are using our workflow templates just run the action `Tinybird - Releases Workflow`.

- In another case you can run the following command from the CLI:
  
```sh
  tb release promote --semver 1.0.0
```

- Or go to the `Releases` section in the UI and promote the `Preview 1.0.0` to `live`.

6. CLEAN-UP: After this point you don't need the resources created to sync and backfill the new Data Source. You can delete the files: `backfill_data.pipe` and `sync_data.pipe` and create a new PR. For this purpose increment the `patch` will be enough (e.g.: `1.0.0` to `1.0.1`).

[Clean-Up Pull Request](https://github.com/tinybirdco/use-case-examples/pull/246/files)
