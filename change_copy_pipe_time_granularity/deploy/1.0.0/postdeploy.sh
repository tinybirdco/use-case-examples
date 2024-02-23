#!/bin/bash
set -euxo pipefail

tb --semver 1.0.0 pipe populate backfill_live_to_new --node migrate_old_copy_bots_snapshot --wait
