# Iterate your API Endpoint

Modifying an endpoint is an easy and straightforward process, but you need to keep a few things in mind to ensure everything works fine after the changes.

> Remember to follow the [instructions](../README.md) to setup your Tinybird Data Project before diving into the use-case steps

1. Breaking change

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/304/files)

In this example, we have an endpoint `top_browsers.pipe` that groups website visits by browser to identify the most frequently used ones. We want to modify it to group the information by both browser and device, that is, changing the API contract.

- Create a new endpoint `pipes/top_browsers_1.pipe`:
- (Optional) Add tests to the project to ensure that endpoint works as expected.

`tests/top_browser_1_default.test`:

```bash
tb pipe data top_browsers1 --date_from 2024-01-11 --date_to 2024-01-12 --format CSV
```

`tests/top_browser_1_default.test.result`:

```
"browser","device","visits","hits"
"chrome","desktop",1,2
"firefox","desktop",1,1
"chrome","mobile-android",1,1
```

- As it is a **breaking change** you keep the old and new version so any client application can start using the new version or rollback to the previous one.

2. Non-breaking change

[Pull Request](https://github.com/tinybirdco/use-case-examples/pull/302/files)

In this example we'll add a new filter to the `top_browser.pipe` Pipe endpoint, without changing the API contract, that is a non-breaking change.

- Change the endpoint `pipes/top_browsers.pipe`
- (Optional) Add tests to the project, as described above, to ensure that endpoint works as expected
- Add the flag `--skip-regression-tests` to your PR. This is required because Tinybird performs some automatic regression tests based on the endpoint's query log history. As we have changed the response of the endpoint, these automatic tests would fail. ([learn more about testing](https://versions.tinybird.co/docs/production/implementing-test-strategies.html)).
