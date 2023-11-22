# Tinybird Versions - Use a new column coming from a Shared Data Source

Sharing Data Sources among multiple workspaces is a common practice. One typical scenario involves having a workspace that houses all landing Data Sources, centralizing all ingestion operations, and then sharing them with specific workspaces.

```mermaid
flowchart LR
    A[("events (in WS A)")]
    B[("A.events (in WS B)")]
    A-->|shared with WS B|B
```

Throughout the lifecycle of a Data Project, it's likely that the landing Data Source schema changes, with new columns being added. In such cases, it becomes necessary to reflect those changes in the Workspaces utilizing the shared Data Source.

This guide will demonstrate how to add new columns from a shared data source to your workspace.

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

Step 1: Obtain the new schema from the landing Data Source

[Step 1 PR](https://github.com/tinybirdco/use-case-examples/pull/78/commits/b086cd00222fc1a33809cf2d0410b742417480fe)

The shared Data Source of a Workspace resides in the `vendor` folder, following the naming pattern `vendor/{ORIGINAL_WORKSPACE}/{DATASOURCE NAME}`.

First of all, create a new Git branch so that all changes can be added to a Pull Request.

```sh
git checkout -b add_new_project_column
```

To use the new columns added in the original Workspace, you need to update the schema by pulling the latest changes.

```sh
tb pull --match analytics_events --force
```

Two important points:

- We use `--match analytics_events` to select the specific Data Source we want to update.
- We use `--force` to actually get the changes. As the Data Source is already in the Workspace, `tb pull` would ignore the file. Using the option `--force` instructs the CLI to overwrite the file with its latest state.

The result is that the schema from the shared Data Source now reflects the new columns present in its original Workspace.

```diff
...
    `session_id` String,
    `action` LowCardinality(String),
    `version` LowCardinality(String),
    `payload` String,
+   `project` String

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
...
```

That's all you need to do to get the latest schema in your Workspace. Since the Data Source is shared, the more complex iteration to bring in the new columns is done in its original workspace. We only need to get the latest schema.

## Step 2: Update the resources that use the shared Data Source

[Step 2 PR](https://github.com/tinybirdco/use-case-examples/pull/78/commits/b086cd00222fc1a33809cf2d0410b742417480fe)

Once you have the latest schema, iterate through the resources that need the newest columns. For brevity, we'll illustrate iterating one endpoint.

In this example, we use the new column `project`` to add a new filter based on a query parameter.

```diff
NODE node_0
SQL >
    %
    SELECT count() as hits
    FROM iv_analytics.analytics_events
    WHERE action = 'page_hit'
        AND timestamp >= {{DateTime(start_from, '2023-11-01 00:00:00')}}
+   {% if (defined(project)) %}
+       AND project = {{String(project)}}
+   {% end %}
```

## Step 3. Add tests

[Step 3 PR](https://github.com/tinybirdco/use-case-examples/pull/78/commits/049835e35128d9cff6bd353562be4cd90f37cc07)

It's convenient to add test to assert that the added code does what it's meant to do. In this example, we've added a filter that shows only the results of a specific project. To check it, we'll add two tests: one to assert that providing an existing project returns results and another one to check that providing a non-existent project name returns no results.

```
- hits_by_using_existing_project:
    max_bytes_read: null
    max_time: null
    sql: |
      SELECT *
      FROM hits_from
      HAVING hits <= 0
    pipe:
      name: hits_from
      params:
        project: 'add_sinks'

- hits_by_using_not_existing_project:
    max_bytes_read: null
    max_time: null
    sql: |
      SELECT *
      FROM hits_from
      HAVING hits > 0
    pipe:
      name: hits_from
      params:
        project: 'a_project_that_does_not_exist'
```

In this example, we provide a project name that we already know that has results and another one that won't exist. A sturdier approach is to provide fixtures, so we don't depend on having the Data Source already populated. For the sake of making this example use case simpler, they're not added, but we recommend you to read the Implementing test strategies guide [link](https://www.tinybird.co/docs/guides/implementing-test-strategies.html#fixture-tests-title) to know more about how to properly test a Data Project.

Now, commit these changes, create a PR, and once the CI pipeline of the created PR validates your changes, you can merge it to deploy in the main environment.
