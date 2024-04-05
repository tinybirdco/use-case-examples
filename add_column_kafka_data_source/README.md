# Add a new column to a Kafka Data Source

> Remember to follow the instructions to set up a fresh Tinybird Workspace to practice this tutorial

With a Kafka Data Source, just add the desired column (in this example, `meta_image_v3`) and set it as Nullable.

> Important! Do not bump the Tinybird version. Bumping it will create a new Data Source instead of altering the current one.

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/194)

```diff
SCHEMA >
     `user_agent` String `json:$.user_agent`,
     `meta_color` Nullable(String) `json:$.meta.color`,
     `meta_size` Nullable(String) `json:$.meta.size`,
     `meta_image` Nullable(String) `json:$.meta.image`
-    `meta_image` Nullable(String) `json:$.meta.image_v2`
+    `meta_image_v2` Nullable(String) `json:$.meta.image_v2`,
+    `meta_image_v3` Nullable(String) `json:$.meta.image_v3`
```

Remember, don't change the version in the `.tinyenv` file. You want to alter the existing Data Source in the `live` release, otherwise a new Data Source will be created.

> There is a CI custom deployment that bypasses a known bug. When working with Kafka connections, it checks that the new columns of the Data Source are in the Data Source's [Quarantine Data Source](https://www.tinybird.co/docs/concepts/data-sources#the-quarantine-data-source), but it doesn't create Quarantine Data Sources in the CI Branches by default. For that reason, it pushes some wrong fixtures which forces the creation of the Quarantine Data Source.

```bash
set +e # Allow errors, the append command will fail
tb datasource append my_kafka_ds datasources/fixtures/my_kafka_ds.ndjson # Hack, it's required to create quarantine table
```

The rest is the similar to what a default deployment without custom script does:

```bash
set -e # Deployment should not fail
tb --semver 0.0.0 deploy --v3 --yes
```
