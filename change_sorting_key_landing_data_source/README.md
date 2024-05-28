# Tinybird Versions - Change Sorting Key to a Landing Data Source

Changing the sorting key of a Data Source requires rewriting the entire table.

You can opt-in by any of these two options:

1. Create a Materialized View where the target Data Source has the desired sorting key.
2. Create a new Data Source with the new sorting key, sync the data with the original table and then exchange both tables.

## 1. New Materialized View

- Create a new Data Source

`datasources/analytics_events_sk.datasource`

```diff
  SCHEMA >
      `timestamp` DateTime `json:$.timestamp`,
      `session_id` String `json:$.session_id`,
      `action` LowCardinality(String) `json:$.action`,
      `version` LowCardinality(String) `json:$.version`,
      `payload` String `json:$.payload`
  
  ENGINE "MergeTree"
- ENGINE_PARTITION_KEY toYYYYMM(timestamp)
+ ENGINE_PARTITION_KEY toYYYYMMDD(timestamp)
  ENGINE_SORTING_KEY timestamp
- ENGINE_SORTING_KEY timestamp, action, version
+ ENGINE_SORTING_KEY "timestamp"
  ENGINE_TTL "timestamp + toIntervalDay(60)"
```

- Create a new Materialized View `sync_analytics_events.pipe` filtering by a date in the future for backfilling purposes

```
NODE sync_analytics_events
SQL >
  SELECT * FROM analytics_events
  WHERE timestamp > '2024-05-28 00:00:00'

TYPE MATERIALIZED
DATASOURCE analytics_events_sk
```

- Create a Copy Pipe `backfill_analytics_events.pipe` for backfilling.

```
NODE backfill_analytics_events
SQL >
  %
  SELECT * FROM analytics_events
  WHERE timestamp BETWEEN {{DateTime(start_backfill_timestamp)}} AND {{DateTime(end_backfill_timestamp)}}
```

- Run CI and merge the Pull Request. To run the backfill do the following (you can test it in CI and then run it after merge):

- Wait for the first event ingested in `analytics_events_sk`
- Run the backfill, you do it with a single command or by chungs:
```
tb pipe copy run backfill_analytics_events --param start_backfill_timestamp='2024-01-01 00:00:00' --param end_backfill_timestamp='2024-05-28 00:00:00' --wait --yes
```

- Cleanup

Once you finish the backfill you can remove the Copy Pipe and start using the new `analytics_events_sk` in your downstream dependencies.

## 2. New Data Source with exchange

Follow the same steps as above, but once the backfill operation over `analytics_events_sk` is finished you can exchange the old and new Data Sources:

```
tb datasource exchange analytics_events analytics_events_sk
```

The exchange command is useful to replace two tables among them when they have the same exact schema. The exchange command is experimental, contact us at `support@tinybird.co` to enable it on your main Workspace.
