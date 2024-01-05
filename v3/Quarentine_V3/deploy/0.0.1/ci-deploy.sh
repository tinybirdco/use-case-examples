#!/bin/bash
set +e

# This line is only for demo purposes, It's adding wrong data to the analytics_events datasource
tb datasource append analytics_events datasources/fixtures/analytics_events_errors.ndjson

set -e

tb deploy --fixtures --v3

sleep 10

tb pipe copy run analytics_events_quarantine_to_final --wait --yes

