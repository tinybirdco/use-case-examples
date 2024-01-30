# Change an S3 Data Source Sorting Key With Reingestion

Altering a sorting key is a complex operation involving multiple steps and requires data migration.

To change the sorting key for an S3 Data Source, there are several possible approaches. Please ensure you have read and understood [this document](../S3_changing_landing_datasource.md) before proceeding.

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
1. Create the new Data Source with new Sorting Key connected to the S3 bucket. 
2. Duplicate and Sync the downstream, except the Pipe endpoints. The downstream are all the resources depending on your Data Source.
3. Wait until the S3 information has been ingested and it's in the new Data Source.
4. Change the Pipe endpoints to point to your new downstream.

## Step 1 and 2: New Data Source and Downstream Replication
This step involves cloning the Data Source whose sorting key we want to alter, along with all dependent Materialized Views, to create a new Downstream branch. This is where you will transition all relevant data to utilize the new Sorting Key by re-ingesting all the data from the S3 bucket.

- Establish a new branch
- Replicate your Data Source with the updated sorting key and bucket URI:
  - `analytics_events.datasource` -> `analytics_events_new (using the new sorting key)`
- Replicate all dependent resources. These include your Data Source and all Materialized Views and Pipes that link them. Do not clone or modify Pipe Endpoints at this time.
  - `analytics_events.datasource` -> `analytics_events_new` (with the new sorting key)
  - `analytics_pages_mv.datasource` -> `analytics_pages_mv_new.datasource`
  - `analytics_sessions_mv.datasource` -> `analytics_session_mv_new.datasource`
  - `analytics_sources_mv.datasource` -> `analytics_sources_mv_new.datasource`
  - `analytics_sessions.pipe` -> `analytics_sessions_new.pipe` (alter to materialize on `analytics_sessions_mv_new.datasource`)
  - `analytics_pages.pipe` -> `analytics_pages_new.pipe` (alter to materialize on `analytics_pages_mv_new.datasource`)
  - `analytics_sources.pipe` -> `analytics_sources_new.pipe` (alter to materialize on `analytics_sources_mv_new.datasource`)
- Push the changes to the branch and initiate a Pull Request. The Continuous Integration (CI) process will validate the changes through Regression, Quality, and Fixture tests ([learn more about testing](https://versions.tinybird.co/docs/version-control/implementing-test-strategies.html)). 
- Before merging, verify your adjustments in the temporary environment that is provisioned.
- Merge the PR to trigger the Continuous Deployment (CD) workflow, and your changes will be propagated to the Main environment.

View the pull request with all changes for this step: [PR Downstream replication](https://github.com/tinybirdco/use-case-examples/pull/97)

(Wait until the DS is Synced within the S3 bucket)

# Step 4

Change the Pipe endpoints to point to the new Downstrem. Then you can remove the legacy Data Source and Downstream.

[Change Pipe endpoints PR](https://github.com/tinybirdco/use-case-examples/pull/98)