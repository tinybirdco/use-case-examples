# Recover data from quarantine V3

When data ends up in quarantine, it is possible to re-ingest it using a Copy Pipe. Create a [Pull Request](https://github.com/tinybirdco/use-case-examples/pull/152) following these steps:

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

- Bump a new CI/CD version and generate deployment scripts `tb release generate --semver 0.0.1`
- In the CI file:
    - Let's append incorrect data to `analytics_events` using a fixture
    - Create a copy Pipe to fix the incorrect data and re-ingest it into `analytics_events`
- In the CD file, it is only needed run the copy Pipe after creation
- The temporal copy pipe will be created inside a Release (0.0.1), once the data is migrated is safe to remove the release:
  ```
  tb release rm --semver 0.0.1
  ```
- Push your changes
