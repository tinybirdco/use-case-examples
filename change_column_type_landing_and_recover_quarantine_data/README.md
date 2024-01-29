## Change landing datasource and recover data from quarantine

You can see what we have modified and the workflows in the [Pull Request](https://github.com/tinybirdco/use-case-examples/pull/228)

First of all, as we are going to change the datasource where the data is being ingested. We need to bump the major version of `.tinyenv`. This will cause will create a Preview release in the branch created by the CI Workflow and also in our workspace by the CD workflow.

Then, we have modified the landing datasource. In this case, we have modified the partition key, but we could have modified any column type

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
- ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
+ ENGINE_PARTITION_KEY "toYYYYMMDD(timestamp)"
ENGINE_SORTING_KEY "timestamp"
ENGINE_TTL "timestamp + toIntervalDay(60)"
```

Then, we have create a materialized view to sync the data that it's arriving to quarantine. To be able to read the data from our Live Release, we will need to specify from which release you want to read. In our case, from `v0.0.1`, so we need to follow the convention `v_0_0_1` 

```sql
NODE materialized
DESCRIPTION >
    This materialized view will connect the data that will arrive to quarantine with the new release (1.0.0)
    This way we can recover the existing data in quarantine and the new data that will arrive to the new release

SQL >
    SELECT 
        assumeNotNull(parseDateTimeBestEffort(replaceAll(timestamp, '"', ''))) as timestamp,
        assumeNotNull(session_id) as session_id,
        toLowCardinality(assumeNotNull(action)) as action,
        toLowCardinality(assumeNotNull(version)) as version,
        assumeNotNull(payload) as payload
    FROM v0_0_1.analytics_events_quarantine

TYPE MATERIALIZED
DATASOURCE analytics_events
```

Finally, as we have modified the landing datasource and therefore, it will create a new one and all the dependent MV. We need to create a materialized view to also connect the data that it is arriving to `analytics_events`.

In our case, as we don't need to do any transformation, we can just do

```sql
NODE materialized
DESCRIPTION >
    This materialized view will connect the ingestion from the Live release ( at the moment v0.0.1 ) to the new release (1.0.0).
    This will allow us to start receiving all the data from the Live release to the new release (1.0.0) that will be in Preview mode.

SQL >
    SELECT *
    FROM v0_0_1.analytics_events

TYPE MATERIALIZED
DATASOURCE analytics_events
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

Now, you show be able to list all the releases we have by doing

```shell
tb release ls
```

Also, you could query the preview release by running the following. In our case, we will be checking the number of rows of `analytics_events`. 
**If you are not ingesting data to the branch is expected that you want see any row as we did not run the populate of the migration pipe**

```shell
tb --semver 1.0.0 sql "SELECT count() FROM analytics_events"
```

At the moment, you need to run the populate command outside git, so you will need to run the following commands in our case

```shell

## This will populate the analytics_events from the Preview release with the data from the Live Release
tb --semver 1.0.0 pipe populate migrate_analytics_events --node materialized --wait

## This will populate the analytics_events from Preview release with the data in quarantine from the Live Release 
tb --semver 1.0.0 pipe populate recover_data_quarantine --node materialized --wait
```

Now, we should be able to see how if we run 

```shell
tb --semver 1.0.0 sql "SELECT count() FROM analytics_events"
```

Finally, you can promote the Preview release to Live Release

```shell
tb release promote --semver 1.0.0
```

### Import limitation of the UI for the Branches

If you go in the UI to the branch created by the CI Workflow, you won't see this changes. That's because you will be seeing the Live Release of the branch and you want be able to acces the Preview Release from the Branch
 
This is a current limitation on the UI only for the Branches that we expect to fix soon. That's why now, you should use the CLI to verify everything is fine in the branch or you can merge the Pull Request and verify everything is fine in the Preview of your workspace


## CD Workflow 

Once we have validated that the migration on the branch worked fine, we would merge the Pull Request and should be able to see the Preview Release on our workspace in the UI or on the CLI.

If you are ingesting continustly, you should be able to see some rows entering in the Preview Release if you the following command. This way we can verify that our Preview Release in in sync with the data that is being ingested in our Live Release.

```shell
tb --semver 1.0.0 sql "SELECT count() FROM analytics_events"
```

Now, we should run the backfill to populate with the historical data. To do that, we can would need to look for the minium timestamp that has been already ingested in the Preview Release. To do that you would need to run. If you do not have a datetime column you can use to do the cut safetly for the backfill, please let us know

```shell
tb --semver 1.0.0 sql "SELECT min(timestamp) FROM analytics_events"
```

With this minium datetime, now we could be able to run the same populate as we did for the branch, but specifying until which datetime we want to run it by following commands

```shell
tb --semver 1.0.0 pipe populate migrate_analytics_events --wait --node materialized --sql-condition "timestamp < '2024-01-29 16:17:02'"
tb --semver 1.0.0 pipe populate recover_data_quarantine --wait --node materialized --sql-condition "insertion_date < '2024-01-29 16:17:02'"
```

Finally, once both populates have been executed correctly, you could compare the datasource in both releases (1.0.0 and 0.0.1 in my case). Both SQL queries should return the same number of rows

```shell
tb --semver 1.0.0 sql "SELECT count() FROM analytics_events"

tb --semver 0.0.1 sql "SELECT count() FROM analytics_events"
```



