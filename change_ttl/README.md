# Tinybird Versions - Change a Data Source's TTL

The Data Source's TTL determines how long data remains valid and accessible within a system. This process is crucial as it ensures data accuracy, relevance, and helps in managing system performance by refreshing or removing outdated information, thereby maintaining the integrity and efficiency of your data infrastructure.

These are the steps in modifying TTL, ensuring there's no data loss during the process.

## Change the ENGINE_TTL setting in a Data Source

Whether it's needed to add a TTL or to change an existing one, the setting to define the TTL is `ENGINE_TTL`

1. Apply the changes to the file

In this example, we're changing the TTL of an existing Data Source from 60 days to 10 days. First of all, we apply the change to the Data Source file `analytics_events.datasource`:

```diff
- ENGINE_TTL "timestamp + toIntervalDay(60)"
+ ENGINE_TTL "timestamp + toIntervalDay(10)"
```

2. Generate a new release

```sh
tb release generate --semver 0.0.1
```

3. Make sure the scripts use the `--yes` flag to force the deployment

```sh
#!/bin/bash
set -e

tb deploy --yes
```

4. Add tests to ensure that the TTL change does not remove existing data

By calling this endpoint, the data should be the same as in the main workspace. This step is very important to ensure the TTL changes don't delete previous data that we don't want to delete.

Since for the testing environment we're using the latest partition for the Data Source, in this case this test should be valid. It's important to take that into account on TTL changes, as we're only testing a subset of the data.

To achieve this, we're adding 8 new rows in the `analytics_events.ndjson` fixture file: 4 of them have a valid TTL the other 4 of them don't. We want to check if the valid ones are correctly inserted, and also we want to check that the invalid ones have not been inserted:

```sh
tb sql "SELECT countIf(toDate(timestamp) = toDate('2022-09-15')) as old_data, countIf(toDate(timestamp) = toDate('2023-10-15')) as current_data FROM analytics_events" --format CSV
```

```csv
"old_data","current_data"
0,4
```

6. Commit the changes and open a new Pull Request.
