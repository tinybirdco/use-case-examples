#!/bin/bash
set +e # Allow errors, first deployment will fail due to quarantine bug
tb --semver 0.0.0 deploy --v3 --yes # Hack, it's required to run the deployment twice until fix quarantine bug
set -e # Second deployment should not fail

tb --semver 0.0.0 deploy --v3 --yes

