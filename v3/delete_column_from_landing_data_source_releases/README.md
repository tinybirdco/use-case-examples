# Tinybird Versions - Delete column from Landing Data Source

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/162/files)

- Delete the desired column from the Data Source
`datasources/analytics_events.datasource`
```diff
SCHEMA >
    `timestamp` DateTime `json:$.timestamp`,
    `session_id` String `json:$.session_id`,
    `action` LowCardinality(String) `json:$.action`,
    `version` LowCardinality(String) `json:$.version`,
-   `environment` Nullable(String) `json:$.environment`,
    `payload` String `json:$.payload`
```
- Add a tag to the same Data Source file to specify the field to use to auto-populate the data
`datasources/analytics_events.datasource`
```diff
ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp"
ENGINE_TTL "timestamp + toIntervalDay(60)"

+ TAGS "backfill_column=timestamp"
```

- Bump the Version to re-create the Data Source
`.tinyenv`
```diff
-   VERSION=0.0.0
+   VERSION=0.0.1
```

- Add a new Materialized Pipe to define how to move the data (copy all the fields except the field being removed)
`datasources/live_to_new.datasource`
```sql
NODE live_to_new
SQL >
    SELECT timestamp, session_id, action, version, payload 
    FROM live.analytics_events
TYPE MATERIALIZED
DATASOURCE analytics_events
```


