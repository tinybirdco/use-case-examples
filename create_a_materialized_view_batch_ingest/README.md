# Tinybird Versions - Create a Materialized View with batch ingest

Creating a Materialized View Data Source is a delicate process that needs to be handled with care to ensure data integrity and continuity. This guide will take you through the steps to achieve this without stopping your data ingestion.

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps
This change needs to re-create the Materialized View and populate it again with all the data without stoping our ingestion.

For that the steps will be:

1. Create the Materialized View (Pipe and Data Source) to improve performance.
1. Adapt the Pipe with the API Endpoint to read from the MV.
1. Bump the version, in our case from 0.0.0 -> 0.0.1. Bumping the version, it will create a new `Preview Release`.
1. Backfill the `Preview Release` Materialized View with the data previous to its creation.
1. Test performance increase.
1. Promote the release from `Preview` to `Live`.

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/210/files)

## 1: Create the Materialized View

- Create the Materialized View: Pipe and Datasource

`events_per_location_mat.pipe`

```sql
NODE count_events_per_location
SQL >

    SELECT
        JSON_VALUE(payload, '$.location') AS location,
        countState() AS hits
    FROM analytics_events
    GROUP BY location

TYPE materialized
DATASOURCE events_per_location_mv
```

`events_per_location_mv.datasource`:

```sql
NODE count_events_per_location
SQL >

    SELECT
        JSON_VALUE(payload, '$.location') AS location,
        countState() AS hits
    FROM analytics_events
    GROUP BY location

TYPE materialized
DATASOURCE events_per_location_mv
```

## 2: Adapt the Endpoint

`events_per_location.pipe`:

```diff
NODE endpoint
SQL >

--    SELECT JSON_VALUE(payload, '$.location') location, count() hits
--    FROM analytics_events
++    SELECT location, countMerge(hits) hits
++    FROM events_per_location_mv
    GROUP BY location
    ORDER BY hits DESC
```

## 3: Bump version

- Bump to the next major version `1.0.0` in the `.tinyenv` file. It will **create** the Materialized View and all its downstream in a new `Preview Release`. I.e., you will have the new resources `events_per_location_mat` and `events_per_location_mv` and a different version of the existing `events_per_location` API Endpoint.

`.tinyenv`:

```diff
-   VERSION=0.0.0
+   VERSION=1.0.0
```

## 4: Backfilling

Once you have deployed the previous changes and they are ready in a `Preview Release` you can opt to backfill the data previous to the Materialized View creation.

Remember that in this example we are not ingesting data constanly to `analytics_events`, so it is safe to run the populate. Up to you to create it as part of the custom post-deploy, or do it manually from the CLI:

- At deployment time

```sh
tb --semver $VERSION pipe populate events_per_location_mat --node count_events_per_location
```

For more complex use cases —i.e. having realtime ingest— check other entries of the [use-case-examples repo](https://github.com/tinybirdco/use-case-examples).

- Manually

Do not add the deploy/1.0.0 files, and do it from the CLI:

```sh
tb --semver 1.0.0 pipe populate events_per_location_mat --node count_events_per_location --wait
```

## 5: Test the performance increase

On the branch your are testing —_main_ or the _tmp*_ one creatd by the CI—, call the endpoint of the current 0.0.0 release and the newly 1.0.0 release to compare performance.

Copy and save the _create_a_materialized_view_batch_ingest_read_ token into a variable

```sh
tb token copy create_a_materialized_view_batch_ingest_read
READTOKEN=$(pbpaste) #example for macOS, for linux you need EPTOKEN=$(xclip -selection clipboard -o)
```

Call the endpoint and check the rows and statistics field.

```sh
curl --compressed -H "Authorization: Bearer $READTOKEN"  https://api.us-east.tinybird.co/v0/pipes/events_per_location.json
```

```json
(...)

"rows": 8,

"statistics":
{
    "elapsed": 0.016005656,
    "rows_read": 16800,
    "bytes_read": 5093413
}
```

Now add the release _?__tb__semver=1.0.0_ to the endpoint and check the results:

```sh
curl --compressed -H "Authorization: Bearer $READTOKEN"  https://api.us-east.tinybird.co/v0/pipes/events_per_location.json?__tb__semver=1.0.0
```

```json
(...)

"rows": 8,

"statistics":
{
    "elapsed": 0.002387179,
    "rows_read": 8,
    "bytes_read": 214
}
```

Depending on your test data you'll see different results, but the improvement will probably be significant.

## 6: Promote the changes

Once the Materialized View has been already populated you can promote the `Preview Release` to `Live`. Choose one of the next 3 options for that:

- If you are using our workflow templates just run the action `Tinybird - Release Workflow`.
  
- Run the following command from the CLI:
  
```sh
  tb release promote --semver 1.0.0
```

- Or go to the `Releases` section in the UI and promote the `Preview 1.0.0`
