#!/bin/bash
set -e

source .tinyenv
tb release create --semver ${VERSION}
tb --semver ${VERSION} deploy --fixtures --fork-downstream
tb release preview --semver ${VERSION}
tb release ls