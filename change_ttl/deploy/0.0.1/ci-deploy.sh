#!/bin/bash
set -e

tb datasource append analytics_events datasources/fixtures/analytics_events.ndjson
tb deploy --yes --populate --fixtures --wait
