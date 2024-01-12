#!/bin/bash
set -e

tb --semver 1.0.0 deploy --wait --v3 # Default deployment
tb --semver 1.0.0 pipe populate backfill_live_to_new --node migrate_old_copy_bots_snapshot --wait
