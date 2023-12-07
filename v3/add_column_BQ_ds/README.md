# Add a new column to a BigQuery Data Source

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

### Alter a BigQuery Data Source in an existing Release

This iteration adds a column in a BigQuery Data Source in the current `live` Release.

[Pull Request #1](https://github.com/tinybirdco/use-case-examples/pull/99)

- Create a new branch
- Create a new BigQuery connection `tb connection create bigquery` 
- Generate the new BigQuery Data Source schema ([instructions](https://www.tinybird.co/docs/ingest/bigquery.html))
- Push your changes
- Once the PR is merged and the CD GitHub Action finishes, you have a new Release in preview status, to get it live run: `tb release --promote <semver>` (where <semver> is the version number of the Release) or select `promote` in the `Select the job to run manually` dropdown inside the `Tinybird - Releases Workflow` GitHub Action.

[Pull Request #2](https://github.com/tinybirdco/use-case-examples/pull/100)

- Create a new branch
- Add a new column to the `bq_pypi.datasource`
- Create a custom deployment (`tb release generate --semver 0.0.2` => in this case 0.0.2 corresponds the current live Release).
- Modify `ci-deploy.sh` and `cd-deploy.sh` to include the alter flag in the deploy command => `tb deploy --yes`. The change will be applied to the current live Release.
- Push your changes
- Once the PR is merged and the CD GitHub Action finishes, since the custom deployment modified the current live Release there's no need to promote.

### Create a new version of a BigQuery Data Source in an new Release

Alternatively you can create a new Release (0.0.3) and create a new version of the `bq_pypi`. Each Release will have a different version with different schema of the BigQuery Data Source. This is convenient if you think a quick rollback is necessary.

[Pull Request #3](https://github.com/tinybirdco/use-case-examples/pull/101)

- Create a new branch
- Add a new `test` column to the `bq_pypi.datasource`
- Create a custom deployment (`tb release generate --semver 0.0.3` => in this case 0.0.3 will create a new Release).
- Modify `ci-deploy.sh` and `cd-deploy.sh` to drop the Data Source before creating it again.
- Push your changes
- Once the PR is merged and the CD GitHub Action finishes, go to Actions -> Tinybird - Releases Workflow -> Run workflow and run the `promote` job in the `main` Branch.
- [Optional] You can rollback to the previous release by running `tb release rollback --semver 0.0.3`. Note when you rollback the live Release will be 0.0.2 and the Release 0.0.3 will be deleted. Also you have to make sure to rollback the changes in your main git branch.

[Internal workspace](https://ui.tinybird.co/a7e39224-c34e-462e-8667-f7ae3cb04c87/dashboard)

