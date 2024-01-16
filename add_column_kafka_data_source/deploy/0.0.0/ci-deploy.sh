#!/bin/bash
set +e # Allow errors, the append command will fail
tb datasource append my_kafka_ds datasources/fixtures/my_kafka_ds.ndjson # Hack, it's required to create quarantine table
set -e # Deployment should not fail

tb --semver 0.0.0 deploy --v3 --yes
