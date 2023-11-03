# Add a new column to a BigQuery Data Source

It isn't possible to add a new column in a BigQuery Data Source in one iteration, but we'll create a new one with the new column and populate it with the old data using a copy Pipe. The steps are:

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

### 1st BigQuery Data Source 

[Pull Request #1](https://github.com/tinybirdco/use-case-examples/pull/15)

- Create a new branch
- Create a new BigQuery connection `tb connection create bigquery` 
- Generate the new BigQuery Data Source schema ([instructions](https://www.tinybird.co/docs/ingest/bigquery.html))
- Push your changes

### 2nd BigQuery Data Source with the new column

[Pull Request #2](https://github.com/tinybirdco/use-case-examples/pull/19)

- Create another branch
- Create a new (and the last) BigQuery Data Source, but this time with the new column. In our case it is `country_code`
- With a copy Pipe, the old data will be copied into the new Data Source
- Generate a new CI/CD version `tb release generate --semver 0.0.1`
- In the CI/CD script files, apart from the deploy command, include the one for copying the data from the old BigQuery Data Source to the new one
- Push your changes

### Remove 1st BigQuery Data Source and populate 2nd BigQuery Data Source

[Pull Request #3](https://github.com/tinybirdco/use-case-examples/pull/24)

- Create the last branch
- Generate a new CI/CD version `tb release generate --semver 0.0.2`
- Let's include in the CI/CD scripts the command to remove the first BigQuery Data Source, becuase it is not needed anymore
- Delete the `.datasource` file
- Push your changes


[Internal workspace](https://ui.tinybird.co/55bd1979-6638-434d-9049-324112188f32/dashboard)