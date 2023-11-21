# Tinybird Versions - Remove Column from a Materialized View Data Source

Removing a column from an existing Materialized View Data Source is a delicate process. This example removes the `browser` column from the `analytics_sessions_mv` Materialized View Data Source as its not being used in the `kpis` Endpoint.

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps


## Step 1: Prepare a Duplicate Materialized View removing the Column

First we can bump the version of the Data Project running `tb release generate --semver 0.0.1` to generate all the required CI/CD files an increase the release VERSION for `.tinyenv`.

Once ready, we need to create a new version of the `analytics_sessions_mv.datasource` and `analytics_sessions.pipe` to include the new definition without the `browse` column.


```diff
---a/change_column_type_to_lowcardinality/datasources/analytics_sessions_mv.datasource
+++b/change_column_type_to_lowcardinality/datasources/analytics_sessions_mv_v1.datasource

 SCHEMA >
     `date` Date,
     `device` SimpleAggregateFunction(any, String),
-    `browser` SimpleAggregateFunction(any, String),
    `location` SimpleAggregateFunction(any, String),
    `first_hit` SimpleAggregateFunction(min, DateTime),
    `latest_hit` SimpleAggregateFunction(max, DateTime),
    `hits` AggregateFunction(count)
```

```diff
---a/change_column_type_to_lowcardinality/datasources/analytics_sessions.pipe
+++b/change_column_type_to_lowcardinality/datasources/analytics_sessions_v1.pipe

SELECT
        toDate(timestamp) AS date,
        session_id, 
        anySimpleState(device) AS device,
-        anySimpleState(browser) AS browser,
        anySimpleState(location) AS location,
        minSimpleState(timestamp) AS first_hit,
        maxSimpleState(timestamp) AS latest_hit,
        countState() AS hits
```

Finally, we need to edit the `cd-deploy.sh` and `ci-deploy.sh` scripts inside the `/deploy/0.0.1/` folder. These scripts will be executed when running the CI and CD and will use the `populate_with_backfill.sh` script to fill the new version of the Materialized View with the existing data from the original datasource.


## Step 2: Clean up

Once, we have validated that everything is working fine with the new version we can create a new Pull Request to remove the previous versions.