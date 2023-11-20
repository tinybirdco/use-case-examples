#!/bin/bash
set -e

tb deploy --fixtures --wait
tb pipe copy run copy_bots_snapshot_old_to_v1 --wait --yes
