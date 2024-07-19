# Alter datasource removing a column

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/347)

- Just remove the column from the schema and apply the changes. If there are dependent materialized views the CLI will list them and ask for confirmation.


```diff
SCHEMA >
-    `version` LowCardinality(String) `json:$.version`,
```

- Create a PR with the change above, a new branch will be created as part of the CI process. You can double check the changes checking the datasource schema.

- To deploy the change, merge to PR to you main branch, the CD job will run and will deploy the changes.

```
...
** Diffs from current commit 'fa782bcbd6907ba013b46c91097949e9413beaa1' and new '6dc57d17508da520fec72c1e970c736400c4cd38':
	modified:	alter_default_value_in_column/datasources/analytics_events.datasource
** Preparing commit ...
** Processing ./datasources/analytics_events.datasource
** Building dependencies
** [DRY RUN] Deploying commit ...
** [DRY RUN] Running 'analytics_events' 
** Deploying commit ...
** Running 'analytics_events' 
** The description or schema of 'analytics_events' has changed.
**   -  DROP COLUMN `version
** The Data Source has been correctly updated.
** 'analytics_events' created
...
```
