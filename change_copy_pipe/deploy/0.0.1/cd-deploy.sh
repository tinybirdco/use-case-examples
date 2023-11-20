#!/bin/bash
set -e

tb deploy
tb pipe copy run copy_bots_snapshot_old_to_v1 --wait --yes
