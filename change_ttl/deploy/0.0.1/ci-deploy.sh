#!/bin/bash
set -e

tb deploy --yes --populate --wait
tb datasource append analytics_events datasources/fixtures/analytics_events.ndjson
