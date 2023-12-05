# Add a new column to a BigQuery Data Source

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

### 1st BigQuery Data Source 

[Pull Request #1](https://github.com/tinybirdco/use-case-examples/pull/15)

- Create a new branch
- Create a new BigQuery connection `tb connection create bigquery` 
- Generate the new BigQuery Data Source schema ([instructions](https://www.tinybird.co/docs/ingest/bigquery.html))
- Push your changes
- Once the PR is merged and the CD GitHub Action finishes. you have a new Release in preview status, to get it live run: `tb release --promote <semver>` (where <semver> is the version number of the Release) or select `promote` in the `Select the job to run manually` dropdown inside the `Tinybird - Releases Workflow` GitHub Action.

[Internal workspace](https://ui.tinybird.co/a7e39224-c34e-462e-8667-f7ae3cb04c87/dashboard)

