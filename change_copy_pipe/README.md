# Tinybird Versions - Change copy pipe to change time granularity



We used copy pipe `bots_snapshot` that is scheduled to every hour do snapshot of bots hits on target `copy_bots_snapshot` Data Source.

We want to change time granularity to day. So, we need:
- new daily copy pipe 
- don't lose hourly data
- calculate current hourly data to new daily granularity


[PR](https://github.com/tinybirdco/use-case-examples/pull/61)
## Step 1: Create a new version of Data Source

Create new version of Data Source `copy_bots_snapshot_v1.datasource` containing the snapshot data with new granularity per day. 

```sql
SCHEMA >
    `date` DateTime,
    `bot_source` String,
    `pathname` String,
    `hits` UInt64

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toDate(date)"
ENGINE_SORTING_KEY "pathname, bot_source, date"
```

Just rename `date_hour` column to more generic `date`
## Step 2: Create a new version of copy pipe

Create new copy pipe with new granularity per day:

- use `toStartOfDay` 
- use as target Data Source new version `copy_bots_snapshot_v1`
- use daily scheduling, i.e every day at 8am

```sql
NODE bot_hits_per_period
SQL >

    SELECT
        toStartOfDay(timestamp) AS date,
        bot_source,
        pathname,
        count() AS hits
    FROM bot_sources
    GROUP BY
        date,
        pathname,
        bot_source

TYPE copy
TARGET_DATASOURCE copy_bots_snapshot_v1
COPY_SCHEDULE 0 8 * * *
```

Now that we are calculating daily snapshot we filter hits just for yesterday.

```sql
AND toStartOfDay(timestamp) = toStartOfDay(now()) - 1
```

## Step 3: Backfill data modifying granularity

We need to backfill new version of Data Source summing old hour granularity to day.

Let's use a Materialized View but we could use another copy pipe to just trigger once

```sql
SQL >
    SELECT toStartOfDay(date_hour) as date, bot_source, pathname, sum(hits) as hits FROM copy_bots_snapshot
    WHERE toDate(date_hour) < today()
    GROUP BY date, pathname, bot_source

TYPE materialized
DATASOURCE copy_bots_snapshot_v1
```

In this case we are stopping backfill on today. Remember in this example we are calculating yesterday snapshot.

## Step 4: Validate changes on CI

Default deployment on CI Environment is enough to deploy new resources, append fixtures and perform the backfill

> By default uses `tb deploy --populate --fixtures --wait` so we can use Materialize View populate as backfill

Then validate changes updating tests:

- fixtures tests: update tests but new fixtures are not need it as we rely on backfill to have desired data in new version
- data quality tests: almost same validations but now asserting daily dates

> Better to rely on backfill instead of generating new static fixtures so we can validate backfill before deploying

## Step 5: Deploy to production

Default CD job is not performing populates by default so we need a custom CD script to perform it.

Use `tb release generate --semver 0.0.1` but just keep `cd-deploy.sh` script from `deploy/0.0.1` path. Then set a deploy with populate option `tb deploy --populate --wait`







