# Add a column to a landing Data Source

> Remember to follow the [instructions](../README.md) to set up a fresh Tinybird Workspace to practice this tutorial

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/206/files)

The process for this example is simpler than most: Just add the desired column.

> Important! Any change to the data project requires bumping the version. In this case, increase the `post-release` part of the semver (the right part following a dash), or you'll re-create a new Data Source instead of altering the current one. This could lead to data loss.

```diff
- 0.0.1
+ 0.0.1-1
```

Depending on the use case, there are 2 different options:

1. If you're already sending the new column to the Data Source, just add the new column with the proper type.

```diff
SCHEMA >
    `timestamp` DateTime `json:$.timestamp`,
    `session_id` String `json:$.session_id`,
    `action` LowCardinality(String) `json:$.action`,
    `version` LowCardinality(String) `json:$.version`,
    `environment` Nullable(String) `json:$.environment`,
+   `new_column` String `json:$.new_column`,
    `payload` String `json:$.payload`
```


2. If you're using the Events API and not always sending data with the new column (for example you have several clients and need to migrate them gradually), you'll need to add it as Nullable. If you don't, the rows sent without the ``new_column`` value will fail and be stored into the Quarantine Data Source.

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


