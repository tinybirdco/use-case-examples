#!/bin/bash
set -e

tb --semver $VERSION deploy --fixtures --populate --wait
