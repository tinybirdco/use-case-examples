# Add a new column to a BigQuery Data Source

It isn't possible to add a new column in a BigQuery Data Source in one iteration, but we'll create a new one with the new column and populate it with the old data. The steps are:

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

### 1st BigQuery Data Source 

Pull Request #1

- Create a new branch
- Generate a new CI/CD version `tb release generate --semver 0.0.1`
- Create a new BigQuery connection `tb connection create bigquery` 
- Generate the new BigQuery Data Source schema ([instructions](https://www.tinybird.co/docs/ingest/bigquery.html))
- Create a Pipe using the new BigQuery Data Source
- In the CI file, populate the data `tb deploy --populate --fixtures --wait`
- In the CD file, `tb deploy`
- Push your changes

### 2nd BigQuery Data Source with the new column

Pull Request #2

### Remove 1st BigQuery Data Source and populate 2nd BigQuery Data Source

Pull Request #3



[Internal workspace](https://ui.tinybird.co/55bd1979-6638-434d-9049-324112188f32/dashboard)