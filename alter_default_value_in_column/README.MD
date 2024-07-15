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

- Create a PR with the change above, a new branch will be created as part of the CI process. You can double check the default value is what you expect by ingesting some null value in the CI branch created.

For instance, in this case ingest an empty event using the Tinybird branch token:

```sh
curl \
      -X POST 'https://api.tinybird.co/v0/events?name=analytics_events' \
      -H "Authorization: Bearer $BRANCH_TOKEN" \
      -d $'{}'
{"successful_rows":1,"quarantined_rows":0}%
```

Check the content of the Data Source:

```
curl https://api.tinybird.co/v0/sql?q=SELECT%20*%20FROM%20analytics_events%20LIMIT%20100%20%0A%20FORMAT%20JSON&token=$BRANCH_TOKEN

{
	"meta":
	[
		{
			"name": "timestamp",
			"type": "DateTime"
		},
		{
			"name": "session_id",
			"type": "String"
		},
		{
			"name": "action",
			"type": "LowCardinality(String)"
		},
		{
			"name": "version",
			"type": "LowCardinality(String)"
		},
		{
			"name": "payload",
			"type": "String"
		}
	],

	"data":
	[
		{
			"timestamp": "2024-07-15 18:04:45",
			"session_id": "",
			"action": "None",
			"version": "1.0",
			"payload": "{}"
		}
	],

	"rows": 1,

	"rows_before_limit_at_least": 1,

	"statistics":
	{
		"elapsed": 0.00113733,
		"rows_read": 1,
		"bytes_read": 26
	}
}
```

You can see all columns have their default value.


- To deploy the change, merge to PR to you main branch, the CD job will run and will deploy the changes.

```
...
** Diffs from current commit '7457be4ad47c137aff1537ae91626b9722c4a89d' and new 'e0c6d30e685bb996c01b2dd37ec66690a2fc0ce8':
	modified:	alter_default_value_in_column/datasources/analytics_events.datasource
** Preparing commit ...
** Processing ./datasources/analytics_events.datasource
** Building dependencies
** [DRY RUN] Deploying commit ...
** [DRY RUN] Running 'analytics_events' 
** Deploying commit ...
** Running 'analytics_events' 
** The description or schema of 'analytics_events' has changed.
**   -  MODIFY COLUMN `timestamp` DEFAULT now()
**   -  MODIFY COLUMN `session_id` DEFAULT ''
**   -  MODIFY COLUMN `action` DEFAULT 'None'
**   -  MODIFY COLUMN `version` DEFAULT '1.0'
**   -  MODIFY COLUMN `payload` DEFAULT '{}'
** The Data Source has been correctly updated.
** 'analytics_events' created
...
```
