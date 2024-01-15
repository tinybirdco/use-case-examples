#!/bin/bash
set +e
tb --semver 0.0.0 deploy --v3 --yes # Hack, it's needed to run the deployment twice until fix quarantine bug
set -e
tb --semver 0.0.0 deploy --v3 --yes