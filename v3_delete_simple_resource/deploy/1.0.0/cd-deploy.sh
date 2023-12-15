#!/bin/bash
set -e

tb --semver $VERSION deploy
tb --semver $VERSION pipe rm kpis --yes
tb --semver $VERSION pipe rm analytics_sessions_mv --yes
tb --semver $VERSION datasource rm analytics_sessions --yes
