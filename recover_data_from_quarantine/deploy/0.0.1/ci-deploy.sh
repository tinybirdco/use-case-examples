#!/bin/bash
set -e

tb datasource append analytics_events datasources/fixtures/analytics_events_errors.ndjson
tb deploy --fixtures
tb pipe copy run analytics_events_quarantine_to_final --wait --yes
# wait 10 seconds so the data quality tests over `datasources_ops_log` have the data available
sleep 10