#!/bin/bash
set -e

tb --semver 0.0.1 deploy --v3
tb --semver 0.0.1 pipe copy run analytics_events_quarantine_to_final --wait --yes
