# Tinybird Versions - Add Column to a Landing Data Source with Specific Values

The process consists on:

1. Add the new column to the landing Data Source
2. Backfill setting the default value
3. Duplicate the downstream dependencies and backfill
4. Update Pipe endpoints to use the new downstream dependencies
5. Cleanup

1. Add the column to the Data Source

[PR](https://github.com/tinybirdco/use-case-examples/pull/290/files)

```diff
SCHEMA >
    `timestamp` DateTime `json:$.timestamp`,
    `session_id` String `json:$.session_id`,
    `action` LowCardinality(String) `json:$.action`,
    `version` LowCardinality(String) `json:$.version`,
+   `environment` String `json:$.environment`,
    `payload` String `json:$.payload`
```

The PR includes a copy Pipe (`backfill_data.pipe`) to backfill historical data setting a default value for the `environment` column. Also note the `backfill_data.pipe` is also a temporary Materialized Pipe to materialize the data being ingested to `analytics_events` into `analytics_events1` until the backfill operation finishes.

2. Backfill
   
Wait for the backfill DateTime (in this case '2024-05-27 11:30:00') and run the copy job.

```
tb pipe copy run backfill_data --param start_backfill_time='2024-01-01 00:00:00' --param end_backfill_time='2024-05-27 11:30:00' --wait --yes
```

3. Duplicate the downstream dependencies and backfill

[PR](https://github.com/tinybirdco/use-case-examples/pull/291/files)

The procedure is similar including a Copy and Materialized Pipe for backfilling purposes. Once the PR is merged, wait for `'2024-05-27 12:00:00'` and run:

```
tb pipe copy run analytics_pages1_backfill --param start_backfill_time='2024-01-01 00:00:00' --param end_backfill_time='2024-05-27 12:00:00' --wait --yes
```

4. Update Pipe endpoints to use the new downstream dependencies

Once Data Sources are synced, you can update Pipe endpoints to make use of the new Dataflow.

[PR](https://github.com/tinybirdco/use-case-examples/pull/292)

5. Cleanup

 After this point, you can start ingesting to `analytics_events1` and remove Pipes created for backfilling

[Clean-Up Pull Request](https://github.com/tinybirdco/use-case-examples/pull/294/files)
