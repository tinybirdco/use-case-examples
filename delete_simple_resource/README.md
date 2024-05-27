# Delete simple resource

Delete simple Data Sources or Pipes easily. Create a [Pull Request](https://github.com/tinybirdco/use-case-examples/pull/308) following these steps:

- Remove from git the Pipes or Data Sources datafiles you want to delete, in this case, `git rm pipes/top_browsers.pipe`
- CI/CD will protect you from removing resources with depedencies and doing in proper order
- Before removing a resource make sure it does not receive any data nor requests by running a query over `datasources_ops_log` or `pipe_stats_rt` like this:

```
select *
from tinybird.datasources_ops_log
where datasource_name = '<datasource_name>'
and timestamp > now() - interval 1 day
```

```
select *
from tinybird.pipe_stats_rt
where pipe_name = '<pipe_name>'
and start_datetime > now() - interval 1 day
```

Adjust the date filter accordingly to make sure the resources are not being used.

[workspace](https://app.tinybird.co/gcp/europe-west3/aab213d8-12a7-46d1-872b-37f3521775e4/)
