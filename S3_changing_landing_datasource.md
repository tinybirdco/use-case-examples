# Options to change a Landing Data Source

Modifying column types, Sorting Key, or Partition Key in a Landing Data Source connected to S3 are changes that cannot be applied directly to the Landing Data Source and require the creation of another Data Source. Depending on the specific use case, there are different possibilities for how to do this:

## Create a new Landing Data Source (+ downstream) and re-consume the information from S3

Perhaps the simplest of the solutions, this approach involves duplicating the Landing Data Source with the desired changes, as well as all the dependent resources, and re-ingesting all the information again from S3. This case is suitable when we have all the necessary info in S3 for the Data Source and also when it is not an excessive data history and much greater than the TTL configured in the Landing Data Source.

[S3 Example #1](./change_sorting_key_to_s3_data_source_with_reingestion)


## Create a new Landing Data Source (+ downstream) and synchronize the data using the Legacy Data Source.

This is the ideal option as we replicate exactly the same data that we had in the original Data Source, but it has a drawback, it is necessary to modify the folder or S3 resource where the information is being dumped, which is not always possible.

[S3 Example #2](./change_sorting_key_to_s3_data_source)

## Create a Materialized View between the Landing Data Source and the resources that depend on it.

This solution involves not touching the Landing Data Source and creating a Materialized View between it and the dependent resources (for example, endpoints), in which we will apply the desired changes. By having a Landing Data Source and a Materialized View, we will be increasing the use of resources.

We don't have an example for this iteration using S3 but it doesn't depend on the kind of connections and it would be the same as [this example](./change_sorting_key_to_kafka_data_source).