#!/bin/bash
set +e
tb datasource append analytics_events datasources/fixtures/analytics_events_errors.ndjson
set -e

tb --semver ${VERSION} deploy --fixtures --populate --wait --v3


