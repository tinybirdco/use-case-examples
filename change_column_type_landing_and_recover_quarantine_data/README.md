## Change landing datasource and recover data from quarantine

You can see what we have modified and the workflows in the [Pull Request](https://github.com/tinybirdco/use-case-examples/pull/300)

We have modified the landing datasource. In this case, we have modified the partition key, but we could have modified any column type

```diff
TOKEN "tracker" APPEND

DESCRIPTION >
    Analytics events landing data source

SCHEMA >
    `timestamp` DateTime `json:$.timestamp`,
    `session_id` String `json:$.session_id`,
    `action` LowCardinality(String) `json:$.action`,
    `version` LowCardinality(String) `json:$.version`,
    `payload` String `json:$.payload`

ENGINE "MergeTree"
- ENGINE_PARTITION_KEY "toYYYYMMDD(timestamp)"
+ ENGINE_PARTITION_KEY "toYear(timestamp)"
ENGINE_SORTING_KEY "timestamp"
ENGINE_TTL "timestamp + toIntervalDay(60)"
```

Then, we have create a materialized view to sync the data that it's arriving to quarantine.

```sql
NODE materialized

SQL >
    SELECT 
        assumeNotNull(parseDateTimeBestEffort(replaceAll(timestamp, '"', ''))) as timestamp,
        assumeNotNull(session_id) as session_id,
        toLowCardinality(assumeNotNull(action)) as action,
        toLowCardinality(assumeNotNull(version)) as version,
        assumeNotNull(payload) as payload
    FROM analytics_events_quarantine

TYPE MATERIALIZED
DATASOURCE analytics_events_1
```

Finally, as we have modified the landing datasource and therefore, it will create a new one and all the dependent MV. We need to create a materialized view to also connect the data that it is arriving to `analytics_events`.

In our case, as we don't need to do any transformation, we can just do

```sql
NODE materialized

SQL >
    SELECT *
    FROM analytics_events

TYPE MATERIALIZED
DATASOURCE analytics_events_1
```

## CI Workflow 

Once the CI Workflow has finished sucessfully, you should be able to authentificate in the branch by either copying the token from the branch or by switching to the branch from main

```shell
# You can use tb authentificate using the token of the branch
tb auth -i 

# You can switch to the branch
tb branch ls 

# By default it is tmp_ci__<PULL_REQUEST_ID>
tb branch use <NAME_BRANCH> 
```

At the moment, you can automate the populate either using a custom deployment that will run on CI/CD or outside git, in this case:

```shell

## This will populate analytics_events_1 from analytics_events
tb pipe populate migrate_analytics_events --node materialized --wait

## This will populate analytics_events_1 from the quarantine table
tb pipe populate recover_data_quarantine --node materialized --wait
```

Now, we should be able to see how if we run 

```shell
tb sql "SELECT count() FROM analytics_events_1"
```

## CD Workflow 

Once we have validated that the migration on the branch worked fine, we would merge the Pull Request and should be able to see the new resources in the PR deployed in the main Workspace.

If you are ingesting continustly, you should be able to see some rows entering in analytics_events_1. This way we can verify that the Materialized Pipes are working as expected.

```shell
tb sql "SELECT count() FROM analytics_events_1"
```

Now, we should run the backfill to populate with the historical data. To do that, we would need to look for the minimum timestamp that has been already ingested in `analytics_events_1`. To do that you would need to run. If you do not have a datetime column you can use to do the cut safetly for the backfill, please let us know

```shell
tb sql "SELECT min(timestamp) FROM analytics_events"
```

With this minimum datetime, now we could be able to run the same populate as we did for the branch, but specifying until which datetime we want to run it by following commands

```shell
tb pipe populate migrate_analytics_events --wait --node materialized --sql-condition "timestamp < '2024-01-29 16:17:02'"
tb pipe populate recover_data_quarantine --wait --node materialized --sql-condition "insertion_date < '2024-01-29 16:17:02'"
```

Finally, once both populates have been executed correctly, you could compare data in both Data Sources. Both SQL queries should return the same number of rows

```shell
tb sql "SELECT count() FROM analytics_events_1"

tb sql "SELECT count() FROM analytics_events"
```

