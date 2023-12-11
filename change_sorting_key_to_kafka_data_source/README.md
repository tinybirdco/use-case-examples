# Change Sorting Key in a Kafka connected Data Source

The solution consists of creating a Materialized View with the desired Sorting Key, between the Kafka Landing Data Source and its endpoints.

## Initial status

We have two endpoints connected to a Kafka Data Source. We want to change the Sorting Key to the Data Source.

![Initial status](imgs/1.png)

[#Project initialization PR](https://github.com/tinybirdco/use-case-examples/pull/103/files)

## Step 1 - Create the Materialized View with the desired Sorting Key

- Create the Materialized Pipe and Data Source with the new desired Sorting Key. ([Pipe](./pipes/mat_product_events.pipe), [Data Source](./datasources/product_events_mv.datasource))
- Push the changes to the branch and initiate a Pull Request. The Continuous Integration (CI) process will validate the changes through Regression, Quality, and Fixture tests ([learn more about testing](https://www.tinybird.co/docs/guides/implementing-test-strategies.html)). 
- Before merging, verify your adjustments in the temporary environment that is provisioned.
- Merge the PR to trigger the Continuous Deployment (CD) workflow, and your changes will be propagated to the Main environment.

![Materialized View without data yet](imgs/2.png)

[#New MV PR](https://github.com/tinybirdco/use-case-examples/pull/104/files)

## Step 2: Backfilling

- Update your Main code branch and initiate a fresh branch.
- Await the pre-set time in the `mat_product_events.pipe` before proceeding with changes.
- Add a backfilling pipe [`backfilling.pipe`](./pipes/backfilling.pipex) to populate old data to your new Data Source.
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
            FROM product_events
            WHERE __timestamp <= NOW() - INTERVAL '10 second'
        ),
        new AS (
            SELECT count() AS cnt
            FROM product_events_mv
            WHERE timestamp <= NOW() - INTERVAL '10 second'
        )
    SELECT curr.cnt - new.cnt AS diff
    FROM curr, new
    WHERE diff != 0
  ```


![After the backfilling both Data Sources have the same data](imgs/3.png)

[#Backfilling PR](https://github.com/tinybirdco/use-case-examples/pull/108/files)

# Final Step - Move the endpoints to the new Materialized View

We've reached the point to change the endpoints to query the new Materialized View instead of the Landing Kafka Data Source.

`last_month_most_selling_products.pipe`:
```diff
@@ -7,10 +7,10 @@ 
SQL >
    SELECT
         product_id, 
         COUNT(*) AS c,
         toMonth(now() - INTERVAL 1 MONTH) as month
-    FROM product_events
+    FROM product_events_mv
     WHERE 
         event_name = 'buy-product' AND 
-        __timestamp >= toStartOfMonth(now()) - INTERVAL 1 MONTH
+        timestamp >= toStartOfMonth(now()) - INTERVAL 1 MONTH
     GROUP BY 
         product_id
     ORDER BY
         c DESC
```

`last_month_most_visited_categories.pipe`:
```diff
@@ -7,10 +7,10 @@ 
SQL >
    SELECT
         product_type, 
         COUNT(*) AS c,
         toMonth(now() - INTERVAL 1 MONTH) as month
-    FROM product_events
+    FROM product_events_mv
     WHERE 
         event_name = 'page-load' AND 
-        __timestamp >= toStartOfMonth(now()) - INTERVAL 1 MONTH
+        timestamp >= toStartOfMonth(now()) - INTERVAL 1 MONTH
     GROUP BY 
         product_type
     ORDER BY
         c DESC
```

![Final picture](imgs/4.png)

[#Endpoints PR](https://github.com/tinybirdco/use-case-examples/pull/106/files)

> We keep the `backfilling.pipe` for demo purposes but at this point it is safe to remove it
