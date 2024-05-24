# Add a new column to a Kafka Data Source

### 1st Create a Kafka Data Source 

[Pull Request #1](https://github.com/tinybirdco/use-case-examples/pull/273)

- Create a new branch
- Create a new Kafka Data Source ([instructions](https://www.tinybird.co/docs/ingest/kafka.html))
- Commit and wait for CI. You can check in the temporary CI branch that everything works as expected.
- Merge and wait for CD.

### 2nd Kafka Data Source with the new column

[Pull Request #2](https://github.com/tinybirdco/use-case-examples/pull/274)

- Create another branch
- Add the new column `meta_image_v3` to the schema
- [Optionally] Update fixtures
- Commit and wait for CI. You can check in the temporary CI branch that everything works as expected.
- Merge and wait for CD.

[Internal workspace](https://app.tinybird.co/gcp/europe-west3/d4808c36-ece2-47c3-b1b7-e95c21fd454b/dashboard)
