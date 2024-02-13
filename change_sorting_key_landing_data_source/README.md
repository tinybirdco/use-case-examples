# Tinybird Versions - Change Sorting Key to a Landing Data Source

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/249)

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps


1. Change the sorting key and partition key of the Data Source:

`datasources/analytics_events.datasource`

```diff
  SCHEMA >
      `timestamp` DateTime `json:$.timestamp`,
      `session_id` String `json:$.session_id`,
      `action` LowCardinality(String) `json:$.action`,
      `version` LowCardinality(String) `json:$.version`,
      `payload` String `json:$.payload`
  
  ENGINE "MergeTree"
- ENGINE_PARTITION_KEY toYYYYMM(timestamp)
+ ENGINE_PARTITION_KEY toYYYYMMDD(timestamp)
  ENGINE_SORTING_KEY timestamp
- ENGINE_SORTING_KEY timestamp, action, version
+ ENGINE_SORTING_KEY "timestamp"
  ENGINE_TTL "timestamp + toIntervalDay(60)"
```

2. Changing the sorting key or partition key requires to re-create the Data Source. Bump the **Major** Version to re-create the Data Source and leave the changes in a `Preview` release to execute backfill migrations in a further step.

`.tinyenv`

```diff
-   VERSION=2.0.1
+   VERSION=3.0.0
```

You can read more about it at https://versions.tinybird.co/docs/version-control/deployment-strategies.html

3. We need to run a backfill to sync the current Live Release with the new Preview Release. To do so, we will use a Materialize View for syncing new incoming data and use a Copy Pipe to run the backfill.

As we need to read the data from the release v2.0.1, we will create the Materialize and Copy Pipe following the convention. `v2.0.1` -> `v2_0_1`. Therefore, `v2_0_1.analytics_events`

First, we will create a Materialized View (MV) named `pipes/syncing_analytics_events.pipe` with the following SQL. 

This MV will start to sync data between release `2.0.1` to `3.0.0` after '2024-02-08 13:45:00' once it will be deployed.


```sql
NODE syncing_data
SQL >
    SELECT * FROM v2_0_1.analytics_events WHERE timestamp > '2024-02-08 13:45:00'

TYPE MATERIALIZED
DATASOURCE analytics_events
```

> We will use a future timestamp to [avoid problems while doing the backfill](https://versions.tinybird.co/docs/version-control/backfill-strategies.html#the-challenge-of-backfilling-real-time-data)

Then, we will create a Copy Pipe `pipes/backfill_analytics_events.pipe` to run to move all the historical data until '2024-02-08 13:45:00', so we will create a Copy Pipe like the following.

```sql
NODE syncing_data
SQL >
    %
    SELECT *
    FROM v2_0_1.analytics_events
    WHERE timestamp BETWEEN {{ DateTime(start) }} AND {{ DateTime(end) }}

TYPE COPY
TARGET_DATASOURCE analytics_events
COPY_SCHEDULE @on-demand
```

Once deployed and we will pass the timestamp '2024-02-08 13:45:00', we will be able to run 

```shell
tb --semver 3.0.0 pipe copy run backfill_analytics_events --param start='1970-01-01 00:00:00' --param end='2024-02-08 13:45:00' --yes --wait
```

Finally, we will create a Pull Request with the changes from above as we have done in https://github.com/tinybirdco/use-case-examples/pull/249/files


## CI Workflow 

Once the CI Workflow will run successfully, we have to do 

1. You authenticate into the branch
2. As you are not appending data, you can run directly `tb --semver 3.0.0 pipe copy run backfill_analytics_events --param start='1970-01-01 00:00:00' --param end='2024-02-08 13:45:00' --yes --wait` or append some dummy data to validate the approach
3. You can run some validations between 2.0.1 vs 3.0.0

```shell

tb --semver 3.0.0 sql "SELECT count() FROM analytics_events"

tb --semver 2.0.1 sql "SELECT count() FROM analytics_events"
```

4. Merge the Pull Request if everything goes fine


## CD Worflow

Once the CD Workflow runs successfully, we have to do:

1. You authenticate into your Live Release
2. You will have to wait until '2024-02-08 13:45:00'
3. Once it is '2024-02-08 13:45:00', you should start seeing data flowing into the Data Source `analytics_events` of the Preview Release
4. Now, we should run the copy pipe `tb --semver 3.0.0 pipe copy run backfill_analytics_events --param start='1970-01-01 00:00:00' --param end='2024-02-08 13:45:00' --yes --wait`.
5. Once the data is migrated, we can promote the release to Live at the UI or the CLI


You can read https://versions.tinybird.co/docs/version-control/backfill-strategies.html#scenario-3-streaming-ingestion-with-incremental-timestamp-column in more details about this strategy and why