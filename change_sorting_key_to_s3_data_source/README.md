# Change an S3 Data Source Sorting Key

Altering a sorting key is a complex operation involving multiple steps and requires data migration.

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

In this example we have changed the Landing Data Source to ingest from S3 appending these lines to the end of the file `analytics_events.datasource`

```sql
... 
IMPORT_SERVICE 's3'
IMPORT_CONNECTION_NAME 'TB-S3-1'
IMPORT_BUCKET_URI 's3://webanalyticstb/v1/*.ndjson'
IMPORT_STRATEGY 'append'
IMPORT_SCHEDULE '@auto'
```

The strategy followed to change the sorting key is:
1. Create the new Data Source with new Sorting Key and reading from a new S3 bucket/folder. In our example we're moving from `s3://webanalyticstb/v1/*.ndjson` to `s3://webanalyticstb/v2/*.ndjson`.
2. Duplicate and Sync the downstream for the new Data Source (without changing the endpoints yet). The downstream are all the resources depending on your Data Source.
3. Once the Data is in Sync change the endpoints to point the new downstream
4. Start storing your new data in the new bucket/folder then you can remove legacy Data Source and its downstream.

## Step 1 and 2: Downstream Replication and Sync Preparation
This step involves cloning the Data Source whose sorting key we want to alter, along with all dependent Materialized Views, to create a new Downstream branch. This is where you will transition all relevant data to utilize the new Sorting Key.

- Establish a new branch
- Replicate your Data Source with the updated sorting key and bucket URI:
  - `analytics_events.datasource` -> `analytics_events_new (using the new sorting key and bucket)`
- Replicate all dependent resources. These include your Data Source and all Materialized Views and Pipes that link them. Do not clone or modify Pipe Endpoints at this time.
  - `analytics_events.datasource` -> `analytics_events_new` (with the new sorting key)
  - `analytics_pages_mv.datasource` -> `analytics_pages_mv_new.datasource`
  - `analytics_sessions_mv.datasource` -> `analytics_session_mv_new.datasource`
  - `analytics_sources_mv.datasource` -> `analytics_sources_mv_new.datasource`
  - `analytics_sessions.pipe` -> `analytics_sessions_new.pipe` (alter to materialize on `analytics_sessions_mv_new.datasource`)
  - `analytics_pages.pipe` -> `analytics_pages_new.pipe` (alter to materialize on `analytics_pages_mv_new.datasource`)
  - `analytics_sources.pipe` -> `analytics_sources_new.pipe` (alter to materialize on `analytics_sources_mv_new.datasource`)
  - `analytics_hits.pipe` -> `analytics_hits_new.pipe` (alter to query  `analytics_events_new.datasource`)
- Create a Materialized Pipe (`new_data_sync.pipe`) to synchronize incoming data from the legacy Data Source to the new one. Implement a filter to sync data only beyond a specific future point. This sets the stage for the subsequent step.
- Push the changes to the branch and initiate a Pull Request. The Continuous Integration (CI) process will validate the changes through Regression, Quality, and Fixture tests ([learn more about testing](https://www.tinybird.co/docs/guides/implementing-test-strategies.html)). 
- Before merging, verify your adjustments in the temporary environment that is provisioned.
- Merge the PR to trigger the Continuous Deployment (CD) workflow, and your changes will be propagated to the Main environment.

View the pull request with all changes for this step: [PR Downstream replication](https://github.com/tinybirdco/use-case-examples/pull/87/files)

## Step 3: Backfilling
- Update your Main code branch and initiate a fresh branch.
- Await the pre-set time in the `new_data_sync.pipe` before proceeding with changes.
- Add a backfilling pipe [`backfilling.pipe`]() to populate old data to your new Data Source and, thereby updating all the downstream.

- Generate a new CI/CD version `tb release generate --semver 0.0.1`
- Modify the CI file:
    - Execute a custom deployment script ensuring fixtures are included for testing and the `backfilling.pipe` populates the new Data Source: tb `deploy --populate --fixtures --wait`

- Modify the CD file:
    - Similar to CI but exluding fixture appending:  `tb deploy --populate --wait`

- Additionally, incorporate a Quality Test to confirm that the row counts in the new and legacy Data Sources align:
  ```sql
    WITH
        curr AS (
            SELECT count() AS cnt
            FROM analytics_events
            WHERE timestamp <= NOW() - INTERVAL '10 second'
        ),
        new AS (
            SELECT count() AS cnt
            FROM analytics_events_new
            WHERE timestamp <= NOW() - INTERVAL '10 second'
        )
    SELECT curr.cnt - new.cnt AS diff
    FROM curr, new
    WHERE diff != 0
  ```
  
- Push your branch, create a PR, and merge after all tests succeed. As always, inspect your temporary environment for the PR to ensure all is in order before advancing to production.

View the pull request with all changes for this step: [PR Backfilling](https://github.com/tinybirdco/use-case-examples/pull/88/files) 
