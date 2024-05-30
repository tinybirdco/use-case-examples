# Tinybird Versions - Create new S3 Data Source

- [Optional] If you don't have any connection created, first you need to create a new one from the main Workspace. You can use the CLI, it's a guided process.

```
tb auth # use the main Workspace admin token
tb connection create s3_iamrole

[1] Log into your AWS Console

Press y to continue: y

[2] Go to IAM > Policies. Create a new policy with the following permissions. Please, replace <bucket> with your bucket name:

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation",
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3:::dev-alrocar"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": "arn:aws:s3:::dev-alrocar/*"
        }
    ]
}

(The policy has been copied to your clipboard)

Press y to continue: y

[3] Go to IAM > Roles. Create a new IAM Role using the following custom trust policy and attach the access policy you just created in the previous step:

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "AWS": "arn:aws:iam::<id>:root"
            },
            "Condition": {
                "StringEquals": {
                    "sts:ExternalId": "<external_id>"
                }
            }
        }
    ]
}

(The policy has been copied to your clipboard)

Press y to continue: y
Enter the ARN of the role you just created: arn:aws:iam::<id>:role/create_s3_datasource
Enter the region where the bucket is located: eu-north-1
Enter the name for this connection: create-s3-datasource

** create-s3-datasource.connection created successfully! Connection details saved in your connection file.
** Info associated with this connection:
** External ID: <external_id>
** Role ARN: arn:aws:iam::<id>:role/create_s3_datasource
```


[Step 1 PR](https://github.com/tinybirdco/use-case-examples/pull/329)

- Create a new branch
- Create a new S3 Data Source using the connection create in the step above or any other connection you want to use from the main Workspace
    ```sql
        SCHEMA >
            `t` String

        ENGINE MergeTree
        ENGINE_SORTING_KEY t

        IMPORT_SERVICE s3_iamrole
        IMPORT_CONNECTION_NAME create-s3-datasource
        IMPORT_BUCKET_URI s3://dev-alrocar/folder1/*.csv
        IMPORT_STRATEGY append
        IMPORT_SCHEDULE @on-demand
    ```
- Commit and wait for CI. You can check in the temporary CI branch that everything works as expected. Note S3 Data Sources do not run in branches, so if you want to run some test you need to use [fixtures](https://www.tinybird.co/docs/production/implementing-test-strategies#fixture-tests)
- Merge and wait for CD.
- [Optionally] Run `tb datasource sync <datasource_name>` to force sync and populate the new Data Source.

[Internal Workspace](https://app.tinybird.co/gcp/europe-west3/create_s3_ds)
