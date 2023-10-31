#!/bin/bash
set -e

tb deploy
tb pipe copy run analytics_events_quarantine_to_final --wait --yes