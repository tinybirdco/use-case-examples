# Tinybird Versions - Add Column to a Landing Data Source

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/296/files)

- Just a add the desired column

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

3. If you want to perform a backfill operation to ingest a default value for the new column read [this example](../add_new_column_with_values/README.md)
