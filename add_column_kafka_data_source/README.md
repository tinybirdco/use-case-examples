# Add a new column to a Kafka Data Source

- Just a add the desired column (`meta_image_v3` in this example), remember to set it as Nullable.

> Important! Not to bump the version, leave it unchanged, other case you'll create a new Data Source instead of altering the current one.

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/188)

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
