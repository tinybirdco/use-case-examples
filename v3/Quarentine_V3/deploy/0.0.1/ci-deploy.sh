#!/bin/bash
set +e
tb datasource append analytics_events datasources/fixtures/analytics_events_errors.ndjson
set -e

tb deploy --fixtures --v3 --yes
tb pipe copy run analytics_events_quarantine_to_final --wait --yes

sleep 10 # wait 10 seconds so the data quality tests over `datasources_ops_log` have the data available



