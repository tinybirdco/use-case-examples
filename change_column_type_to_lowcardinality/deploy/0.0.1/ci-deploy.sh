#!/bin/bash
set -e

tb deploy
../utils/populate_with_backfill.sh "date" "analytics_pages_mv_v1" "analytics_pages_v1" "analytics_pages_1" "analytics_pages_mv"  "" "timestamp"
