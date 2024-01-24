#!/bin/bash
set -e

tb --semver $VERSION pipe populate events_per_location_mat --node count_events_per_location
