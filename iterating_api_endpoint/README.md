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

- As it is a **breaking change** let's deploy changes to a `Preview` release. This way we have both versions available in Tinybird. In this case we increase the major version, bump the semver version in `.tinyenv`.

`.tinyenv`:
```diff
- 0.0.0
+ 1.0.0
```

- Create a Pull Request with these changes and, once all the checks are satisfied, merge it. Then the `Preview` release will be created with the endpoint changes. From this moment, you can start to migrate all the API consumers to use the new version `1.0.0`. Just add  `__tb__semver=1.0.0` to the url. Once `0.0.0` can be securely deprecated, promote `preview` to `live` following one of the next options:

    - The action `Tinybird - Releases Workflow` in the case you are using our workflow templates.
    - Promote from the UI.
    - Or CLI:

        ```sh
        tb release promote --semver 1.0.0
        ```

- Then you can get rid of `__tb__semver=1.0.0` on your service to be ready for next not breaking changes.

- In this case Tinybird rollback is availabke but not useful as your API consumer is not compatible wit both versions.


> In case we are iterating **not a breaking change** the way to go is just to Deploy to a `Live` release (bumping minor or patch in `.tinyenv`). API consumer does not require any change and Tinybird rollback is available.


