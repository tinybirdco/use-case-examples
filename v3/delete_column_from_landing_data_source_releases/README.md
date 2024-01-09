# Tinybird Versions - Delete column from Landing Data Source

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/162/files)

- Delete the desired column from the Data Source:
  
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

- Column deletion requires to re-create the Data Source. Bump the Version to re-create the Data Source.
  
`.tinyenv`

```diff
-   VERSION=0.0.0
+   VERSION=0.0.1
```

- When a Data Source is recreated, needs to be populated with data. For that is needed to set a DateTime field that represents the date of the data samples. This file is used to create filters under the hood to distinguish the data being populated and the fresh data reaching the Data Source, avoiding to create duplicates.
  
`datasources/analytics_events.datasource`

```diff
ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp"
ENGINE_TTL "timestamp + toIntervalDay(60)"

+ TAGS "backfill_column=timestamp"
```

- Add a new Materialized Pipe to define how to move the data from the legacy Data Source to the new being re-created (copy all the fields except the field being removed).
  
`datasources/live_to_new.datasource`

```sql
NODE live_to_new
SQL >
    SELECT timestamp, session_id, action, version, payload 
    FROM live.analytics_events
TYPE MATERIALIZED
DATASOURCE analytics_events
```

- Push your changes to a branch, pass all the checks and merge it. At that moment there will be a new release '0.0.1' where you can check all the data is OK and promote to live whatever of the next options:

    - The action `Tinybird - Releases Workflow` in the case you are using our workflow templates.
    - Promote from the UI.
    - Or CLI:

        ```sh
        tb release promote --semver 0.0.1
        ```


