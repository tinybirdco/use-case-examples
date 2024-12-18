# Tinybird Versions - Create a Materialized View with batch ingest

Creating a Materialized View Data Source is a delicate process that needs to be handled with care to ensure data integrity and continuity. This guide will take you through the steps to achieve this without stopping your data ingestion.

This change needs to re-create the Materialized View and populate it again with all the data without stoping our ingestion.

For that the steps will be:

1. Create the Materialized View (Pipe and Data Source) to improve performance.
2. Create a new Pipe with the API Endpoint to read from the MV.
3. Deploy.
4. Backfill the new Materialized View with the data previous to its creation.
5. Test performance increase.
6. Start using the new Materialized View.

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
SCHEMA >
    `location` String,
    `hits` AggregateFunction(count)

ENGINE "AggregatingMergeTree"
ENGINE_SORTING_KEY "location"
```

## 2: Create the Endpoint

`events_per_location_1.pipe`:

```diff
NODE endpoint
SQL >

    SELECT location, countMerge(hits) hits
    FROM events_per_location_mv
    GROUP BY location
    ORDER BY hits DESC
```

## 3: Deploy

- Commit to a Pull Request to run on a Tinybird Branch as part of CI.
- Merge the Pull Request to deploy the changes to the main Workspace as part of CD.

## 4: Backfilling

Once you have deployed the previous changes and they are ready either in the CI branch or in the main Workspace you can opt to backfill the data previous to the Materialized View creation.

Remember that in this example we are not ingesting data constanly to `analytics_events`, so it is safe to run the populate. 

```sh
tb pipe populate events_per_location_mat --node count_events_per_location --wait
```

## 5: Test the performance increase

On the branch your are testing —_main_ or the _tmp*_ one creatd by the CI—, call the new and old endpoints to compare performance.

Copy and save the _create_a_materialized_view_batch_ingest_read_ token into a variable

```sh
tb token copy create_a_materialized_view_batch_ingest_read
READTOKEN=$(pbpaste) #example for macOS, for linux you need EPTOKEN=$(xclip -selection clipboard -o)
```

Call the endpoint and check the rows and statistics field.

```sh
curl --compressed -H "Authorization: Bearer $READTOKEN"  https://api.tinybird.co/v0/pipes/events_per_location.json
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

Now the new endpoint:

```sh
curl --compressed -H "Authorization: Bearer $READTOKEN"  https://api.tinybird.co/v0/pipes/events_per_location_1.json
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

## 6: Start using the new Materialized View

Now the Materialized View has been deployed and validated you can decide keep the new endpoint `events_per_location_1` and drop the old one, or just create a new PR to update `events_per_location` to use the Materialized view and drop `events_per_location_1`.
