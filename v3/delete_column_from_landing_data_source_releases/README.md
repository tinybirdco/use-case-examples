# Tinybird Versions - Delete column from Landing Data Source

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

- Just delete the desired column from the Data Source

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/162/files)

```diff
SCHEMA >
    `timestamp` DateTime `json:$.timestamp`,
    `session_id` String `json:$.session_id`,
    `action` LowCardinality(String) `json:$.action`,
    `version` LowCardinality(String) `json:$.version`,
-   `environment` Nullable(String) `json:$.environment`,
    `payload` String `json:$.payload`
```