# Tinybird Versions - Add Column to a Landing Data Source

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/206/files)

- Just a add the desired column, remember to set it as Nullable.

> Important! Any change to the data project requires to bump the version. In this case, increase the `post-release` part of the semver (the right part following a dash), other case you'll re-create a new Data Source instead of altering the current one what could lead to a data loss.

```diff
- 0.0.1
+ 0.0.1-1
```

```diff
SCHEMA >
    `timestamp` DateTime `json:$.timestamp`,
    `session_id` String `json:$.session_id`,
    `action` LowCardinality(String) `json:$.action`,
    `version` LowCardinality(String) `json:$.version`,
    `environment` Nullable(String) `json:$.environment`,
+   `new_column` Nullable(String) `json:$.new_column`,
    `payload` String `json:$.payload`
```

> TODO: Adding not nullable columns is a more delicated action we'll explain in a further example.