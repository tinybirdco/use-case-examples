# Add a new column to a BigQuery Data Source

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

### 1st BigQuery Data Source 

[Pull Request #1](https://github.com/tinybirdco/use-case-examples/pull/99)

- Create a new branch
- Create a new BigQuery connection `tb connection create bigquery` 
- Generate the new BigQuery Data Source schema ([instructions](https://www.tinybird.co/docs/ingest/bigquery.html))
- Push your changes
- Once the PR is merged and the CD GitHub Action finishes, you have a new Release in preview status, to get it live run: `tb release --promote <semver>` (where <semver> is the version number of the Release) or select `promote` in the `Select the job to run manually` dropdown inside the `Tinybird - Releases Workflow` GitHub Action.

[Pull Request #1](https://github.com/tinybirdco/use-case-examples/pull/100)

- Create a new branch
- Add a new column to the `bq_pypi.datasource`
- Create a custom deployment (`tb release generate --semver 0.0.2` => in this case 0.0.2 corresponds the current live Release) to alter the table with `tb deploy --yes` in the current live Release.
- Push your changes
- Once the PR is merged and the CD GitHub Action finishes, since the custom deployment modified the current live Release there's no need to promote.

[Internal workspace](https://ui.tinybird.co/a7e39224-c34e-462e-8667-f7ae3cb04c87/dashboard)

