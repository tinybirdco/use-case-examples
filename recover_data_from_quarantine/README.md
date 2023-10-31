# Recover data from quarantine

When data ends up in quarantine, it is possible to re-ingest it using a Copy Pipe. Create a [Pull Request](https://github.com/tinybirdco/use-case-examples/pull/6) following these steps:

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

- Create a new branch
- Generate a new CI/CD version `tb release generate --semver 0.0.1`
- In the CI file:
    - Let's append incorrect data to `analytics_events` using a fixture
    - Create a copy Pipe to fix the incorrect data and re-ingest it into `analytics_events`
- In the CD file, it is only needed run the copy Pipe after creation
- Let's create data quality tests with the errored rows are there and the copy operation is executed after some seconds
- Push your changes


[Internal workspace](https://ui.tinybird.co/dc247b6f-ce82-4bf0-bd22-50b1b0fd000a/dashboard)