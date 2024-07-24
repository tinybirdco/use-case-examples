# Recover data from quarantine

When data ends up in quarantine, it is possible to re-ingest it using a Copy Pipe. Create a pull request following these steps:

- Create a new pipe to select, fix and copy the quarantine rows. In our case it looks like [analytics_events_quarantine_to_final.pipe](./pipes/analytics_events_quarantine_to_final.pipe):
  ```sql
  NODE copy_quarantine
  SQL >
      SELECT
          toDateTime(
              fromUnixTimestamp64Milli(toUInt64(assumeNotNull(timestamp)) * 1000)
          ) timestamp,
          assumeNotNull(session_id) session_id,
          assumeNotNull(action) action,
          assumeNotNull(version) version,
          assumeNotNull(payload) payload
      FROM analytics_events_quarantine

  TYPE COPY
  TARGET_DATASOURCE analytics_events
  ```
- Create a custom deployment `0.0.1`
- In the custom deployment file [deploy.sh](./deploy/0.0.1/deploy.sh):
    - Let's append incorrect data to `analytics_events` using a fixture (that's required to create the quarantine Data Source)
    ```bash
      set +e
      tb datasource append analytics_events datasources/fixtures/analytics_events_errors.ndjson
      set -e
    ```
    - Don't forget `set +e` command when the incorrect data is being appended, if not the pipeline will finish with error.
    - Run the copy Pipe to fix the incorrect data and re-ingest it into `analytics_events`
    ```bash
    tb pipe copy run analytics_events_quarantine_to_final --wait --yes
    ```
    - You can also add a test to check that the copy is working and you get data in `analytics_events`. In this case we're looking for a row we know exists in the quarantine.
    ```bash
    output=$(tb sql "SELECT * FROM analytics_events WHERE session_id == 'b7b1965c-620a-402a-afe5-2d0eea0f9a34'")
    if [[ $output == *"No rows"* ]]; then
        echo "Information was not copied from quarantine to final Data Source 'analytics_events'"
        exit 1
    fi
    ```
- Once you test the copy Pipe in CI you can get rid of the custom deployment and merge the Pull Request.
- After the changes are merged you can run the copy Pipe in the main Workspace.
  ```
  tb pipe copy run analytics_events_quarantine_to_final --wait --yes
  ``` 
