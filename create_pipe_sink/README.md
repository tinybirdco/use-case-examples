# Tinybird Versions - Create Pipe Sink to S3

[Pull Request for these changes](https://github.com/tinybirdco/use-case-examples/pull/264)

This example is based in our [web analytics starter kit](https://github.com/tinybirdco/web-analytics-starter-kit) demo project.

We aim to run a daily sink to capture the bots' hits in an S3 JSON file.

The steps include:

- Creating a Pipe to gather data on the bots' hits.

- Setting up a connection with your S3 bucket.

- Scheduling the sink to execute daily at 15:00 PM.

The UI is required for creating the connection to S3, making it the preferred method for setting up the sink. If you already have a connection, you can modify the data project using your preferred IDE without using the UI. Keep in mind, using the UI or your IDE, you will achieve the same outcome: the pull request (PR) linked in this document.

## Create a Pipe to get the bots' hits data
When using the UI, the first step is to create a new branch. Then, in that branch, add the desired Pipe with the data mapping for the S3 sink.

In our case, we've created the `bots_snapshot.pipe`.

[pipes/bots_snapshot.pipe](./pipes/bots_snapshot.pipe)

## Setup a connection with your S3 bucket
Through the UI, for the created Pipe, select the option Create a Sink. Click Create a new connection and follow the instructions to establish a new connection to your desired destination. Detailed steps for authentication will be provided by the UI.

## Schedule the sink
After creating and authenticating the connection, you can configure the remaining settings for your Pipe Sink. This can be done through the same wizard or by modifying the Pipe file. Here are the settings for this example:

`bot_snapshot.pipe`

```diff
+ TYPE SINK
+ EXPORT_SERVICE s3_iamrole
+ EXPORT_CONNECTION_NAME s3sink
+ EXPORT_SCHEDULE 0 15 * * *
+ EXPORT_BUCKET_URI s3://sinks02/bot_hits_per_period
+ EXPORT_FILE_TEMPLATE hits_{date}
+ EXPORT_FORMAT ndjson
+ EXPORT_COMPRESSION None
+ EXPORT_STRATEGY @new
```

- **`TYPE SINK`**: This specifies the type of Pipe as a Sink, indicating its role is to export data to an external storage system.

- **`EXPORT_SERVICE s3_iamrole`**: Defines the service used for exporting data. `s3_iamrole` means that the data will be exported to an Amazon S3 bucket using an IAM role, which provides secure access without needing to embed explicit credentials.

- **`EXPORT_CONNECTION_NAME s3sink`**: This is a user-defined name that represents the specific connection details to your S3 bucket. In this case, `s3sink` is used as an identifier.

- **`EXPORT_SCHEDULE 0 15 * * *`**: Determines when the sink operation is performed, using cron syntax. `0 15 * * *` means the sink will execute daily at 15:00 PM UTC.

- **`EXPORT_BUCKET_URI s3://sinks02/bot_hits_per_period`**: Specifies the URI of the target S3 bucket and the path where the files will be saved. This includes the bucket name (`sinks02`) and a directory/path (`bot_hits_per_period`).

- **`EXPORT_FILE_TEMPLATE hits_{date}`**: Sets the naming template for the exported files. `{date}` is a placeholder that will be replaced with the value of the same field in your Pipe helping organize and identify the files easily. If different rows result in the same file name, they will be appended together into a single file.

- **`EXPORT_FORMAT ndjson`**: The format of the exported data. `ndjson` stands for Newline Delimited JSON, which is ideal for processing data one record at a time. Other options are `Avro`, `CSV`, `ORC` or `parquet`. 

- **`EXPORT_COMPRESSION None`**: Specifies the compression method for the files. `None` indicates no compression will be applied. Other options like `gzip`, `LZ4`, `XZ`, `ZST`, `Brotli` or `BZ2` could be used for compressing the files to save space and reduce transfer times.


## Deploy the changes

- It is mandatory to use the `alter deployment strategy` ([more about deployment strategies](https://www.tinybird.co/docs/version-control/deployment-strategies.html)) for this type of changes. Therefore, increment the post-release segment of the semver version (e.g., from 0.0.1 to 0.0.1-1).

`.tinyenv`

```diff
-   VERSION=0.0.1
+   VERSION=0.0.1-1
```

- Push your changes to a Git branch, create a PR, ensure all checks pass, and merge it. Wait until the CD workflow finishes, and you will get a new live release with your new Sink Pipe ready.
