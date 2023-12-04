# Change an S3 Data Source Sorting Key With Reingestion

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