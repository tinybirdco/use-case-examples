# Tinybird Versions - Create pipe sink to S3

[Pull Request for these changes](https://github.com/tinybirdco/use-case-examples/pull/264)

This example is based in our [web analytics starter kit](https://github.com/tinybirdco/web-analytics-starter-kit) demo project.

We aim to run a daily sink to capture the bots' hits in an S3 JSON file.

The steps include:

- Creating a pipe to gather data on the bots' hits.
- Setting up a connection with your S3 bucket.
- Scheduling the sink to execute daily at 12:00 PM.

The UI is required for creating the connection to S3, making it the preferred method for setting up the sink. If you already have a connection, you can modify the data project using your preferred IDE without using the UI. Keep in mind, using the UI or your IDE, you will achieve the same outcome: the pull request (PR) linked in this document.

## Create a pipe to get the bots' hits data
When using the UI, the first step is to create a new branch. Then, in that branch, add the desired Pipe with the data mapping for the S3 sink.

In our case, we've created the `bots_snapshot.pipe`.

[pipes/bots_snapshot.pipe](./pipes/bots_snapshot.pipe)

## Setup a connection with your S3 bucket
Through the UI, for the created pipe, select the option Create a Sink. Click Create a new connection and follow the instructions to establish a new connection to your desired destination. Detailed steps for authentication will be provided.

## Schedule the sink
After creating and authenticating the connection, you can configure the remaining settings for your Pipe Sink. This can be done through the same wizard or by modifying the pipe file. Here are the settings for this example:

`bot_snapshot.pipe`

```diff
+ TYPE SINK
+ EXPORT_SERVICE s3_iamrole
+ EXPORT_CONNECTION_NAME s3sink
+ EXPORT_SCHEDULE 0 12 * * *
+ EXPORT_BUCKET_URI s3://sinks02/bot_hits_per_period
+ EXPORT_FILE_TEMPLATE hits_{date}
+ EXPORT_FORMAT ndjson
+ EXPORT_COMPRESSION None
+ EXPORT_STRATEGY @new
```

You can explore the different options and much more in our [documentation page](https://www.tinybird.co//docs/publish/s3-sink).

## Deploy the changes

- It is mandatory to use the `alter deployment strategy` ([more about deployment strategies](https://www.tinybird.co/docs/version-control/deployment-strategies.html)) for this type of changes. Therefore, increment the post-release segment of the semver version (e.g., from 0.0.1 to 0.0.1-1).

`.tinyenv`

```diff
-   VERSION=0.0.1
+   VERSION=0.0.1-1
```

- Push your changes to a Git branch, create a PR, ensure all checks pass, and merge it. Wait until the CD workflow finishes, and you will get a new live release with your new Sink Pipe ready.
