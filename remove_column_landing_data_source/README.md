# Tinybird Versions - Remove column from Landing Data Source

- Create a new Data Source without the column:

`datasources/analytics_events_1.datasource`

```diff
SCHEMA >
    `timestamp` DateTime `json:$.timestamp`,
    `session_id` String `json:$.session_id`,
    `action` LowCardinality(String) `json:$.action`,
    `version` LowCardinality(String) `json:$.version`,
-   `environment` Nullable(String) `json:$.environment`,
    `payload` String `json:$.payload`
```

- Add a new Materialized Pipe to define how to move the data from the legacy Data Source to the new being re-created. 

`pipes/old_to_new.pipe`

```sql
NODE old_to_new_node
SQL >
    SELECT timestamp, session_id, action, version, payload 
    FROM analytics_events

TYPE MATERIALIZED
DATASOURCE analytics_events_1
```

- Deploy your changes to a branch, create a PR and pass all the checks. 
- At this moment you can decide if you want to backfill the old data. If it's the case, you can execute the following command:


  ```bash
  tb pipe populate old_to_new --node old_to_new_node --sql-condition "timestamp < $BACKFILL_DATE" --wait
  ```

  where `$BACKFILL_DATE` is your earliest date in the new Data Source `analytics_events_1`.

- Once data is synchronized change ingestion to `analytics_events_1` and update the downstream dependencies to use `analytics_events_1`