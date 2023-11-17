# Tinybird Versions - Change column from String to LowCardinality(String)

This update involves several changes aimed at optimizing the storage and query performance of the `analytics_pages_mv` datasource. The primary change is the conversion of the `browser` column from a `String` type to a `LowCardinality(String)` type. 

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

## Step 1: Create a new version of the materialized view (MV) https://github.com/tinybirdco/use-case-examples/pull/51

First, we can run `tb release generate --semver 0.0.1`, so it will generate all the required files like CD/CI in case you don't have them and increase the `VERSION` inside `.tinyenv` to indicate we are going to release a new version.

Then, we would need to create a new version of the resouces and change the column type from `String` to `LowCardinality(String)` and 

```diff
--- a/change_column_type_to_lowcardinality/datasources/analytics_pages_mv.datasource
+++ b/change_column_type_to_lowcardinality/datasources/analytics_pages_mv_v1.datasource
@@ -1,8 +1,7 @@
-
 SCHEMA >
     `date` Date,
     `device` String,
-    `browser` String,
+    `browser` LowCardinality(String),
     `location` String,
     `pathname` String,
     `visits` AggregateFunction(uniq, String),
```

```diff
--- a/change_column_type_to_lowcardinality/pipes/analytics_pages.pipe
+++ b/change_column_type_to_lowcardinality/pipes/analytics_pages_v1.pipe
@@ -7,7 +7,7 @@ SQL >
     SELECT
         toDate(timestamp) AS date,
         device,
-        browser,
+        toLowCardinality(browser) as browser,
         location,
         pathname,
         uniqState(session_id) AS visits,
```

Finally, we need to create two new deploy scripts `deploy/0.0.1/cd-deploy.sh` and `deploy/0.0.1/ci-deploy.sh`. These new deployment scripts will be executed when running the CI and CD and will use the `populate_with_backfill` script to fill the new version of the MV with the existing data from the landing datasource


## Step 2: Remove previous version of the materialize view

Once, we have validated that everything is working fine with the new version of the MV. 

We can create a new PR, where we remove the previous version to avoid having duplicated MVs and we increase the `VERSION` inside `.tinyenv`
