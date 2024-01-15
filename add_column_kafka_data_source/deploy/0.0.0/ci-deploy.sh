#!/bin/bash
set -e

tb --semver 0.0.0 deploy --v3 --yes # Hack to avoid --fixtures, which has a known bug being fixed
