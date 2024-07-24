## Change landing datasource and recover data from quarantine

We are going to change the `version` column from String to UInt32. Let's start by creating a new Data Source `analytics_events_1.datasource`

```diff
TOKEN "tracker" APPEND

SCHEMA >
    `timestamp` DateTime `json:$.timestamp`,
    `session_id` String `json:$.session_id`,
    `action` LowCardinality(String) `json:$.action`,
    - `version` LowCardinality(String) `json:$.version`,
    + `version` UInt32 `json:$.version`,
    `payload` String `json:$.payload`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp"
ENGINE_TTL "timestamp + toIntervalDay(60)"
```

Then, we have create a Materialized View `recover_data_quarantine.pipe` to sync the data that it's arriving to quarantine. 

```sql
NODE materialized

SQL >
    SELECT 
        assumeNotNull(parseDateTimeBestEffort(timestamp)) as timestamp,
        assumeNotNull(session_id) as session_id,
        toLowCardinality(assumeNotNull(action)) as action,
        toUInt32(assumeNotNull(version)) as version,
        assumeNotNull(payload) as payload
    FROM analytics_events_quarantine

TYPE MATERIALIZED
DATASOURCE analytics_events_1
```

Since we created a new Data Source `analytics_events_1` we need to create a materialized view to also connect the data that it is arriving to `analytics_events`.

In our case, as we don't need to do any transformation, we can just create `migrate_analytics_events.pipe` like this:

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


We will be checking the number of rows of `analytics_events`. 
**If you are not ingesting data to the branch is expected that you want see any row as we did not run the populate of the migration pipe**

```shell
tb sql "SELECT count() FROM analytics_events_1"
```

Run the populate command:

```shell

## This will populate the analytics_events from the old Data Source to the new one
tb pipe populate migrate_analytics_events --node materialized --wait

## This will populate the analytics_events from the quarantine table
tb pipe populate recover_data_quarantine --node materialized --wait
```

Data should be now synchronized:

```shell
tb sql "SELECT count() FROM analytics_events_1"
```

## CD Workflow 

Once we have validated that the migration on the branch worked fine, we would merge the Pull Request so the changes are deployed to the main Workspace.

If you are ingesting continously, you should be able to see some rows entering in the new `analytics_events_1` Data Source.

```shell
tb "SELECT count() FROM analytics_events_1"
```

Run the backfill to populate with the historical data. To do that, look for the minimum timestamp that has been already ingested in the new Data Source.

```shell
tb sql "SELECT min(timestamp) FROM analytics_events_1"
```

Use that date for the backfilling operation:

```shell
tb pipe populate migrate_analytics_events --wait --node materialized --sql-condition "timestamp < '2024-01-29 16:17:02'"
tb pipe populate recover_data_quarantine --wait --node materialized --sql-condition "insertion_date < '2024-01-29 16:17:02'"
```

Finally, once both populates have been executed correctly, you could compare both Data Sources to make sure data has been synchronized:

```shell
tb sql "SELECT count() FROM analytics_events_1"

tb sql "SELECT count() FROM analytics_events"
```



