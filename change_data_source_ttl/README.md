# Tinybird Versions - Change a Data Source's TTL

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/234/files)

The Data Source's TTL determines how long data remains valid and accessible. This process is crucial as it ensures data accuracy, relevance, and helps in managing system performance by refreshing or removing outdated information.

These are the steps in modifying TTL, ensuring there's no data loss during the process.

## Change the ENGINE_TTL setting in a Data Source

Whether it's needed to add or to change the TTL, the setting to define it is `ENGINE_TTL`

- Apply the changes to the file

In this example, we're changing the TTL of an existing Data Source from 60 days to 10 days. First of all, we apply the change to the Data Source file `analytics_events.datasource`:

```diff
- ENGINE_TTL "timestamp + toIntervalDay(60)"
+ ENGINE_TTL "timestamp + toIntervalDay(10)"
```

- Make sure you increment the `Post-Release` segment of the SemVer number in `.tinyenv` file: 
  
```bash
- VERSION=0.0.0-1
+ VERSION=0.0.0-2
```

  This alters the Data Source to change the TTL, if you changed another part of the SemVer, the Data Source would be re-created, and it's not what we want. Check [deployment strategies documentation](https://versions.tinybird.co/docs/version-control/deployment-strategies.html#semver-deployment-behaviour) to learn more about the different strategies applying changes to your Data Project.

- Add tests to ensure that the TTL change is working as expected:

We're adding 8 new rows in the `analytics_events.ndjson` fixture file: 4 of them have a valid TTL the other 4 of them don't. We want to check if the valid ones are correctly inserted, and also we want to check that the invalid ones (15 days ago in the moment of creating this tutorial) have not been inserted:

```sh
tb sql "SELECT countIf(toDate(timestamp) = toDate('2024-01-15')) as old_data, countIf(toDate(timestamp) = toDate('2026-09-15')) as current_data FROM analytics_events" --format CSV
```

```csv
"old_data","current_data"
0,4
```

- Commit the changes and open a new Pull Request, it will create a CI branch when you can double check that the TTL change is being applied as expected. Once all the checks are ok merge it, and the changes will be deployed to the `live` release.
