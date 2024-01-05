#!/bin/bash
tb deploy --fixtures --v3

set +e
tb datasource append analytics_events datasources/fixtures/analytics_events_errors.ndjson
set -e

tb pipe copy run analytics_events_quarantine_to_final --wait --yes

