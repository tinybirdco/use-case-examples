#!/bin/bash
set -e

source .tinyenv
tb release create --semver ${VERSION}
tb --semver ${VERSION} deploy --fixtures --fork-downstream --populate --wait
tb release preview --semver ${VERSION}
tb release promote --semver ${VERSION}
tb release ls
