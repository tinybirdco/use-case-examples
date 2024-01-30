# Tinybird Versions - Change column from String to LowCardinality(String)

This update aims at optimizing the storage and query performance of the `analytics_pages_mv` datasource. The change is the conversion of the `browser` column from a `String` type to a `LowCardinality(String)` type. 

To change a column type in a Materialized View Data Source is a process that needs to be handled with care to ensure data integrity and continuity. This guide will take you through the steps to achieve this without stopping your data ingestion.

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

This change needs to re-create the Materialized View and populate it again with all the data without stoping our ingestion.

For that the steps will be:

1. Modify the Materialized View (Pipe and Data Source) to change the type to the colum.
2. Bump version from 0.0.0 -> 1.0.0 in the `.tinyenv` file. Bumping the major version will create a new `Preview Release` internally forking the Materialized View and its dependencies.
3. Backfill the `Preview Release` Materialized View with the data previous to its creation.
4. Promote the release from `Preview` to `Live`.

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/175/files)

## 1: Change the Materialized View

- Change the Materialized View: Pipe and Datasource

`analytics_pages_mv.datasource`:
```diff
 SCHEMA >
     `date` Date,
     `device` String,
-    `browser` String,
+    `browser` LowCardinality(String),
     `location` String,
     `pathname` String,
     `visits` AggregateFunction(uniq, String),
```

`analytics_pages.pipe`
```diff
     SELECT
         toDate(timestamp) AS date,
         device,
-        browser,
+        toLowCardinality(browser) as browser,
         location,
         pathname,
         uniqState(session_id) AS visits,
```

## 2: Bump version
- Bump to the next **major** version `1.0.0` in the `.tinyenv` file. It will **re-create** the Materialized View and all its downstream in a new `Preview Release`. 

`.tinyenv`
  ```diff
-   VERSION=0.0.0
+   VERSION=1.0.0
  ```

Please note that in this Preview Release we're ingesting the production data, but `analytics_pages_mv` lacks the rows prior to its recent creation. We show how to backfill it in the next step.

## 3: Backfilling 
Once you have deployed the previous changes and they are ready in a `Preview Release` you can opt to backfill the data previous to the Materialized View re-creation.

- Get the creation date by executing the following command
```sh
tb --semver 1.0.0 datasource ls
```
or executing this query using the CLI or the UI dashboard

```sh
tb --semver 1.0.0 sql "select timestamp from tinybird.datasources_ops_log where event_type = 'create' and datasource_name = 'analytics_pages_mv' order by timestamp desc limit 1"
```

- Use the creation date to populate the Materialized View with the data previous to its creation:
```sh
tb --semver 1.0.0 pipe populate analytics_pages --node analytics_pages_1 --sql-condition "timestamp < '$CREATED_AT' --wait
```

## 4: Promote the changes
Once the Materialized View has been already populated you can promote the `Preview Release` to `Live`. Choose one of the next 3 options for that:

- If you are using our workflow templates just run the action `Tinybird - Releaseas Workflow`.

- In other case you can run the following command from the CLI:
  
```sh
  tb release promote --semver 1.0.0
```

- Or go to the `Releases` section in the UI and promote the `Preview 1.0.0` to `live`.