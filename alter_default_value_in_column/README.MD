# Alter DEFAULT value in a column of the landing Data Source

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/340/files)

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

- Create a PR with the change above, a new branch will be created as part of the CI process. You can double check the default value is what you expect by ingesteing some null value in the CI branch created.
- To deploy the change, merge to PR to you main branch, the CD job will run and will deploy the changes.
