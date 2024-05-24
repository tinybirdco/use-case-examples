# Tinybird Versions - Add Column to an S3 Data Source

[Step 1 PR](https://github.com/tinybirdco/use-case-examples/pull/281)

- Create a new branch
- Modify `analytics_events.datasource` to include the new column:
    ```sql
        SCHEMA >
            `timestamp` DateTime `json:$.timestamp`,
            `session_id` String `json:$.session_id`,
            `action` LowCardinality(String) `json:$.action`,
            `version` LowCardinality(String) `json:$.version`,
            `environment` Nullable(String) `json:$.environment`, -- New column
            `payload` String `json:$.payload`
    ```
- Commit and wait for CI. You can check in the temporary CI branch that everything works as expected.
- Merge and wait for CD.
- [Optionally] Run `tb datasource sync analytics_events` to force sync and populate the new column.

[Internal Workspace](https://ui.tinybird.co/7e0624bd-635c-4d21-b4b1-436114425add/dashboard)
