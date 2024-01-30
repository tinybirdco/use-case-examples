# Tinybird Versions - Add Column to a Landing Data Source

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/206/files)

- Just a add the desired column

> Important! Any change to the data project requires to bump the version. In this case, increase the `post-release` part of the semver (the right part following a dash), other case you'll re-create a new Data Source instead of altering the current one what could lead to a data loss.

```diff
- 0.0.1
+ 0.0.1-1
```

Depending on the use case, there are different options:

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


2. If you're using the Events API and not always sending data with the new column (for example you have several clients and need to migrate them gradually). You'll need to add it as Nullable. In other case, the rows sent without the ``new_column`` value will fail and be stored into the Quarantine Data Source.

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


