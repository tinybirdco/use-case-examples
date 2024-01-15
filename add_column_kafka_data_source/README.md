# Add a new column to a Kafka Data Source

In this use case we are going to add a column to a Kafka Data Source. The same steps will work independently of the MergeTree engine used.

### 1st Kafka Data Source 

[Pull Request #1](https://github.com/tinybirdco/use-case-examples/pull/79)

You have already created a Kafka Data Sources using the UI or with CLI following [the docs](https://www.tinybird.co/docs/ingest/kafka.html).

### Add the new column to the kafka Data Source

[Pull Request #2](https://github.com/tinybirdco/use-case-examples/pull/83)

- Create a new branch
- Add a new column in the Data Source. For example you can do:
```diff
diff --git a/add_column_kafka_data_source/datasources/my_kafka_ds.datasource b/add_column_kafka_data_source/datasources/my_kafka_ds.datasource
index 72ae19b..ff621f9 100644
--- a/add_column_kafka_ds/datasources/my_kafka_ds.datasource
+++ b/add_column_kafka_ds/datasources/my_kafka_ds.datasource
@@ -12,7 +12,8 @@ SCHEMA >
     `user_agent` String `json:$.user_agent`,
     `meta_color` Nullable(String) `json:$.meta.color`,
     `meta_size` Nullable(String) `json:$.meta.size`,
-    `meta_image` Nullable(String) `json:$.meta.image`
+    `meta_image` Nullable(String) `json:$.meta.image`,
+    `meta_image_v2` Nullable(String) `json:$.meta.image_v2`
```

