# Add a new column to a Kafka Data Source

- Just a add the desired column (`meta_image_v3` in this example), remember to set it as Nullable.

> Important! Not to bump the version, leave it unchanged, other case you'll create a new Data Source instead of altering the current one.

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
- Make sure you don't change the version in the `.tinyenv` file. We want to alter the existing Data Source in the `live` release and in other case a new data source would be created.

> We added a CI custom deployment that is only required to bypass a known bug. Basically, when working with kafka connections we check that the new columns of the Data Source are in the Data Source's Quarantine Data Source, but we don't create Quarantine Data Sources in the CI Branches by default. For that reason, we push some wrong fixtures which forces the Quarantine Data Source creation.

```bash
set +e # Allow errors, the append command will fail
tb datasource append my_kafka_ds datasources/fixtures/my_kafka_ds.ndjson # Hack, it's required to create quarantine table
```

The rest is the similar to what a default deployment without custom script does:

```bash
set -e # Deployment should not fail
tb --semver 0.0.0 deploy --v3 --yes
```
