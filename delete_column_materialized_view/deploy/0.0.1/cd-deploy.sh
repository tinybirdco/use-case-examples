#!/bin/bash
set -e

tb deploy 
../utils/populate_with_backfill.sh "date" "analytics_sessions_mv_v1" "analytics_sessions_v1" "analytics_sessions_1" "analytics_sessions_mv" "" "timestamp"