# Tinybird Versions - Alter DEFAULT value in a column of the landing Data Source

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/338/files)

- Just a add the default values to the desired columns. If the event is not sending the value or it is null, the default value will be applied.


```diff
SCHEMA >
+    `timestamp` DateTime `json:$.timestamp` DEFAULT now(),
+    `session_id` String `json:$.session_id` DEFAULT '',
+    `action` LowCardinality(String) `json:$.action` DEFAULT 'None',
+    `version` LowCardinality(String) `json:$.version` DEFAULT '1.0',
+    `payload` String `json:$.payload` DEFAULT '{}',
-    `timestamp` DateTime `json:$.timestamp`,
-    `session_id` String `json:$.session_id`,
-    `action` LowCardinality(String) `json:$.action`,
-    `version` LowCardinality(String) `json:$.version`,
-    `payload` String `json:$.payload`
```
