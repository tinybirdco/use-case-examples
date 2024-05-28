# Tinybird Versions - Change copy pipe to change time granularity

[Pull Request of this changes](https://github.com/tinybirdco/use-case-examples/pull/255)

We have implemented the `bots_snapshot` Copy Pipe, which runs hourly to capture the bots' hits on the `copy_bots_snapshot` Data Source.

We want to change time granularity to day. So, we need:
- New daily copy pipe 
- Don't lose hourly data
- Calculate current hourly data to new daily granularity


## Create a new Data Source with the changes needed

The required changes (schema + new data granularity) imply re-creating the Data Source. 

`datasoures/copy_bots_snapshot_1.datasource`

```diff
SCHEMA >
+   `date` DateTime,
-   `date_hour` DateTime,
    `bot_source` String,
    `pathname` String,
    `hits` UInt64

ENGINE "MergeTree"
+ ENGINE_PARTITION_KEY "toDate(date)"
+ ENGINE_SORTING_KEY "pathname, bot_source, date"
- ENGINE_PARTITION_KEY "toDate(date)"
- ENGINE_SORTING_KEY "pathname, bot_source, date"
```

Just rename `date_hour` column to a more generic `date`
  
## Create a new copy Pipe to have a per day time granularity

- Use `toStartOfDay` 
- Use daily scheduling, i.e every day at 8 am

`pipes/bot_snapshot_1.pipe`

```diff
NODE bot_hits
SQL >
     SELECT
        timestamp,
        action,
        version,
        coalesce(session_id,'0') as session_id,
        JSONExtractString(payload, 'locale') as locale,
        JSONExtractString(payload, 'location') as location,
        JSONExtractString(payload, 'referrer') as referrer,
        JSONExtractString(payload, 'pathname') as pathname,
        JSONExtractString(payload, 'href') as href,
        lower(JSONExtractString(payload, 'user-agent')) as user_agent
     FROM
        analytics_events
     where action = 'page_hit' AND match(user_agent, 'wget|ahrefsbot|curl|urllib|   bitdiscovery|\+https://|googlebot')
+    AND toStartOfDay(timestamp) = toStartOfDay(now()) - 1

  NODE bot_sources
  SQL >

    SELECT
      timestamp,
      action,
      version,
      session_id,
      location,
      referrer,
      pathname,
      href,
      case
        when match(user_agent, 'wget') then 'wget'
        when match(user_agent, 'ahrefsbot') then 'ahrefsbot'
        when match(user_agent, 'curl') then 'curl'
        when match(user_agent, 'urllib') then 'urllib'
        when match(user_agent, 'bitdiscovery') then 'bitdiscovery'
        when match(user_agent, '\+https://|googlebot') then 'googlebot'
        else 'unkown'
      END as bot_source
    FROM
      bot_hits

- NODE bot_hits_per_hour
+ NODE bot_hits_per_period
  SQL >
    SELECT
-       toStartOfHour(timestamp) AS date_hour,
+       toStartOfDay(timestamp) AS date,
        bot_source,
        pathname,
        count() AS hits
    FROM bot_sources
    GROUP BY
+        date,
-        date_hour,
         pathname,
         bot_source

  TYPE copy
  TARGET_DATASOURCE copy_bots_snapshot_1
- COPY_SCHEDULE 0 * * * *
+ COPY_SCHEDULE 0 8 * * *
```

Now that we are calculating daily snapshots we filter hits just for yesterday.

```sql
AND toStartOfDay(timestamp) = toStartOfDay(now()) - 1
```

## Backfill old data by modifying granularity (optional)

If desired, we can backfill the re-created Data Source summing old hour granularity to day.

Let's prepare a Materialized View for that.

`backfill_live_to_new.pipe`
```sql
SQL >
    SELECT toStartOfDay(date_hour) as date, bot_source, pathname, sum(hits) as hits FROM copy_bots_snapshot
    WHERE toDate(date_hour) < today()
    GROUP BY date, pathname, bot_source

TYPE materialized
DATASOURCE copy_bots_snapshot_1
```

This Materialized Pipe gets the data from the old Data Source and will copy it in the new one, changing the time granularity. In this case, we are stopping backfill on today. Remember in this example we are calculating yesterday's snapshot.

Run the backfill:

```bash
tb pipe populate backfill_live_to_new --node migrate_old_copy_bots_snapshot --wait
```

## Deploying the changes

- Push your changes to a branch, create a PR and pass all the checks. You can check everything is OK in the `tmp_ci_` Tinybird Branch created as part of the CI pipeline.

Once you've validated the changes merge the Pull Request and run the backfill operation in the main Workspace.

## Cleanup

Last step consists on cleaning up the old resources. Just `git rm` the old Copy Pipe and Data Source, create a new Pull Request and merge it to remove them from the main Workspace.