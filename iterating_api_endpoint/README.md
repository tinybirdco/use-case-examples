# Iterate your API Endpoint

Modifying an endpoint is an easy and straightforward process, but you need to keep a few things in mind to ensure everything works fine after the changes.

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before diving into the use-case steps

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/201/files)

In this example, we have an endpoint `top_browsers.pipe` that groups website visits by browser to identify the most frequently used ones. We want to modify it to group the information by both browser and device.

- Change the endpoint `pipes/top_browsers.pipe`:
  
```diff
@@ -15,6 +15,7 @@ SQL >
    %
            select
            browser,
+           device,
            uniqMerge(visits) as visits,
            countMerge(hits) as hits
            from
@@ -31,7 +32,7 @@ SQL >
                and date <= today()
            {% end %}
            group by
-           browser
+           browser, device
            order by
            visits desc
            limit {{Int32(skip, 0)}},{{Int32(limit, 50)}}
```

- (Optional) Add tests to the project to ensure that endpoint works as expected.

`tests/top_browser_default.test`:

```bash
tb pipe data top_browsers --date_from 2024-01-11 --date_to 2024-01-12 --format CSV
```

`tests/top_browser_default.test.result`:

```
"browser","device","visits","hits"
"chrome","desktop",1,2
"firefox","desktop",1,1
"chrome","mobile-android",1,1
```

- Add the flag `--skip-regression-tests` to your PR. This is required because Tinybird performs some automatic regression tests based on the endpoint's query log history. As we have changed the response of the endpoint, these automatic tests would fail. ([learn more about testing](https://versions.tinybird.co/docs/version-control/implementing-test-strategies.html)).

- Bump the semver version in `.tinyenv`. In this case we increase the major version. Doing so will deploy the changes in a `Preview` release.

`.tinyenv`:
```diff
- 0.0.0
+ 1.0.0
```

- Create a Pull Requet with these changes and, once all the checks are satisfied, merge it. Then the `Preview` release will be created with the endpoint changes. From this moment, you can start to migrate all the API consumers to use the new version `1.0.0`. Once `0.0.0` can be securely deprecated, promote `preview` to `live` following one of the next options:

    - The action `Tinybird - Releases Workflow` in the case you are using our workflow templates.
    - Promote from the UI.
    - Or CLI:

        ```sh
        tb release promote --semver 1.0.0
        ```
- After this moment, if something goes wrong, you will be able to rollback to the `0.0.0` release.
