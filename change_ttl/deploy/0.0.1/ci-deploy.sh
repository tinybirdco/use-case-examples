#!/bin/bash
set -e

tb datasource append analytics_events datasources/fixtures/analytics_events.ndjson
tb deploy --yes --populate --fixtures --wait

WAIT_SECONDS_FOR_MERGE=5
echo "Waiting for $WAIT_SECONDS_FOR_MERGE seconds..."
sleep "$WAIT_SECONDS_FOR_MERGE"
echo "Done waiting."
