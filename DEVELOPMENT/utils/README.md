# Utils

## query_apis.sh

A script to request all the endpoints within the web_analytics_data_project. Useful to get the metrics needed to run the regression tests.

Usage:
```sh
  ./DEVELOPMENT/utils/query_apis.sh --token <token> --nreq <number_of_requests> [--host <host>]
    --token    Authorization token for accessing the endpoints.
    --nreq     Number of times requests will be made to each endpoint.
    --host     The host to send requests to. Defaults to 'api.tinybird.co'.
    -h         Display this help message.
```

## init_project.sh

This Bash script initialize the project in your local and creates a the Workspace with all the resources and data in the `analytics_events` Data Source.

You will only need to push your changes at the end.

```sh
./DEVELOPMENT/utils/init_project.sh
```
