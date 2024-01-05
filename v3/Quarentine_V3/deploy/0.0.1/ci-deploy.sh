#!/bin/bash
set +e
tb datasource append analytics_events datasources/fixtures/analytics_events_errors.ndjson
set -e

tb deploy --fixtures --v3
tb pipe copy run analytics_events_quarantine_to_final --wait --yes

# Checks if quarantine info was copied checking if one of the fixtures exist in the final Data Source
output=$(tb sql "SELECT * FROM analytics_events WHERE session_id == 'b7b1965c-620a-402a-afe5-2d0eea0f9a34'")
if [[ $output == *"No rows"* ]]; then
    echo "Information was not copied from quarantine to final Data Source 'analytics_events'"
    exit 1
fi
