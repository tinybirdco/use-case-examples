# How to create a "Use case" example

It is necessary a Tinybird Data Project, with Versions enabled, and connected to Git before starting. 

> ⚠️ REMEMBER to create an initial PR (Pull Request) with all the project initialization and boilerplate code. For clarity, subsequent PRs should be concise and specifically tailored to the use cases they solve.

By default, the [web-analytics-starter-kit](https://github.com/tinybirdco/web-analytics-starter-kit) Data Project will be used. In this folder we provide the [data project](web_analytics_data_project) ready to be pushed to your empty Workspace.

These are the steps we follow for creating a new "use case" example:

- Create a new branch
- Add a new folder (without spaces) with the name of the use case
- Go to the folder
- With `tb`, create a new empty workspace `tb workspace create use_case_name`
- Enable versions and protect `main` for that new Workspace
- Download the `web_analytics_data_project` and place all the files in your folder
- Add the CI and CD workflows in `.github/workflows` folder. Try to use the same name as described in the first step with `_cd` and `_ci` at the end. Pay special attention to `paths` and `data_project_dir` variables.
- Push your files to the Workspace `tb push`. In case you have any previous resource in the Workspace, `tb workspace clear`
- Append data using `mockingbird-cli`. `mockingbird-cli tinybird --template "Web Analytics Starter Kit" --token <ADMIN_TOKEN> --datasource "analytics_events" --endpoint "<REGION>" --eps 100 --limit 1000`
- Make requests over your API Endpoints. In the `utils` folder, there is a script for making requests over the API Endpoints. Example of usage: `query_apis.sh --token <TOKEN> --nreq 10`
- Connect your workspace to Git `tb init --git` ([documentation](https://www.tinybird.co/docs/guides/working-with-git.html))
- Push your changes

> If you don't want to run this process manually, we have a script in our [`utils`](utils) section that will save you some time
