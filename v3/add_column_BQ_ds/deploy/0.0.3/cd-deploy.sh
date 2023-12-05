#!/bin/bash
set -e

tb release create --semver ${VERSION}
tb --semver ${VERSION} deploy --yes
tb release preview --semver ${VERSION}
tb release promote --semver ${VERSION}
tb release ls
