# Tinybird Versions - Remove column from Landing Data Source

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/232/files)

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

- Column deletion requires to re-create the Data Source. Bump the **Major** Version to re-create the Data Source and leave the changes in a `Preview` release to execute backfill migrations in a further step.

`.tinyenv`

```diff
-   VERSION=0.0.1
+   VERSION=1.0.0
```

- Add a new Materialized Pipe to define how to move the data from the legacy Data Source to the new being re-created. In other words, to sync the data from `live` to `preview`. Take into account that only the new data will be synced. We'll explain how to backfill the data previous to the new release creation in a further step.

`pipes/v001_to_v100.pipe`

```sql
NODE live_to_new
SQL >
    SELECT timestamp, session_id, action, version, payload 
    FROM v0_0_1.analytics_events
TYPE MATERIALIZED
DATASOURCE analytics_events
```


- Push your changes to a branch, create a PR and pass all the checks. As we're creating a new empty `analytics_events` Data Source the regression tests will fail so you need to bypass them by adding the tag `--skip-regression-tests` to the PR. Now you can merge the PR and a new `preview` Release `1.0.0` will be created, where you can check everything is OK. 

- At this moment you can decide if you want to backfill the old data. If it's the case, you can execute the following command:


  ```bash
  tb --semver 1.0.0 pipe populate v000_to_v1000 --node v000_to_v1000 --sql-condition "timestamp < $BACKFILL_DATE" --wait
  ```

  where `$BACKFILL_DATE` is your earliest date in the re-generated Data Source `analytics_events` in the `Preview Release`.

- Once you're happy with your Preview Release you can promote it to `live` following one of the next options:

    - The action `Tinybird - Releases Workflow` in the case you are using our workflow templates.
    - Promote from the UI.
    - Or CLI:

        ```sh
        tb release promote --semver 1.0.0
        ```
