# Tinybird Versions - Change a Data Source's TTL

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/178/files)

The Data Source's TTL determines how long data remains valid and accessible within a system. This process is crucial as it ensures data accuracy, relevance, and helps in managing system performance by refreshing or removing outdated information, thereby maintaining the integrity and efficiency of your data infrastructure.

These are the steps in modifying TTL, ensuring there's no data loss during the process.

## Change the ENGINE_TTL setting in a Data Source

Whether it's needed to add a TTL or to change an existing one, the setting to define the TTL is `ENGINE_TTL`

- Apply the changes to the file

In this example, we're changing the TTL of an existing Data Source from 60 days to 10 days. First of all, we apply the change to the Data Source file `analytics_events.datasource`:

```diff
- ENGINE_TTL "timestamp + toIntervalDay(60)"
+ ENGINE_TTL "timestamp + toIntervalDay(10)"
```

- Make sure you don't update the version in the `.tinyenv` file. It would create a new empty version of the Data Source instead of altering the current one.

- Add tests to ensure that the TTL change is working as expected:

To achieve this, we're adding 8 new rows in the `analytics_events.ndjson` fixture file: 4 of them have a valid TTL the other 4 of them don't. We want to check if the valid ones are correctly inserted, and also we want to check that the invalid ones (11 days ago) have not been inserted:

```sh
tb sql "SELECT countIf(toDate(timestamp) = toDate('2023-31-12')) as old_data, countIf(toDate(timestamp) = toDate('2026-09-15')) as current_data FROM analytics_events" --format CSV
```

```csv
"old_data","current_data"
0,4
```

- Commit the changes and open a new Pull Request, it will create a CI branch when you can double check that the TTL change is being applied as expected. Once all the checks are ok merge it, and the changes will be deployed to the `live` release.
