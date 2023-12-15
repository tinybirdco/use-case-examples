#!/bin/bash
set -e

tb release create --semver ${VERSION}
tb --semver ${VERSION} datasource rm bq_pypi --yes
tb --semver ${VERSION} deploy --fixtures --populate --wait
tb release preview --semver ${VERSION}
tb release promote --semver ${VERSION}
tb release ls
