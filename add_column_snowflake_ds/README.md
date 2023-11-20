# Add a new column to a Snowflake Data Source

It is not possible to add a new column to a Snowflake Data Source in one iteration. These are the steps to follow:

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before jumping into the use-case steps

### Create a Snowflake Data Source with the new column

[Pull Request #1](https://github.com/tinybirdco/use-case-examples/pull/67)

- Create a branch from `main`
- Create the new Snowflake Data Source with the new column, `volume` in this case.
- Create a copy Pipe with the new column as `null`, selecting all the data from the origin Data Source and with the new Data Source as the target.
- Generate a new CI/CD version `tb release generate --semver 0.0.1`
- In the CI/CD script files, apart from the deploy command, add the command needed to run the copy Pipe.
- Push your changes and create a Pull Request to merge your branch into `main`
