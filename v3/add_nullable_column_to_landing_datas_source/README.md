# Tinybird Versions - Add Column to a Landing Data Source

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

- Just a add the desired column, remember to set it as Nullable.

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/156/files)

```diff
SCHEMA >
    `timestamp` DateTime `json:$.timestamp`,
    `session_id` String `json:$.session_id`,
    `action` LowCardinality(String) `json:$.action`,
    `version` LowCardinality(String) `json:$.version`,
+   `environment` Nullable(String) `json:$.environment`,
    `payload` String `json:$.payload`
```

> TODO: Adding not nullable columns is a more delicated action we'll explain in a further example.
