# Tinybird Versions - Delete column from Landing Data Source

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps


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
+   VERSION=0.1.0
```

- Add a new Materialized Pipe to define how to move the data from the legacy Data Source to the new being re-created. In other words to move copy the from "live" to "preview". Take into account that only the new data will be synced. We'll explain how to backfill the data previous to the new release creation in a further step.
  
`datasources/live_to_new.datasource`

```sql
NODE live_to_new
SQL >
    SELECT timestamp, session_id, action, version, payload 
    FROM live.analytics_events
TYPE MATERIALIZED
DATASOURCE analytics_events
```

- Push your changes to a branch, pass all the checks and merge it. At that moment there will be a new `preview` release `0.1.0` where you can check everything is OK. 
  
- At this moment you can decide if you want to backfill the old data. If it's the case, you can create a new PR with a custom deployment within the following command:
  
  ```bash
  tb --semver 0.0.1 pipe populate live_to_new --node live_to_new --sql-condition "timestamp < $BACKFILL_DATE" --wait
  ```
  
  where `$BACKFILL_DATE` is your earliest date in the re-generated Data Source in the `Preview Release`.

- Once you're happy with your Preview Relase you can promote it to `live` following whatever of the next options:

    - The action `Tinybird - Releases Workflow` in the case you are using our workflow templates.
    - Promote from the UI.
    - Or CLI:

        ```sh
        tb release promote --semver 0.1.0
        ```
