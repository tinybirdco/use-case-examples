#!/bin/bash
set -e

tb --semver 1.0.0 pipe populate live_to_new --node live_to_new --sql-condition "timestamp < '2024-01-12T00:00:00.00Z'" --wait
