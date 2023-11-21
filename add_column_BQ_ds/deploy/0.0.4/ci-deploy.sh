#!/bin/bash
set -e

tb deploy --populate --fixtures --wait --yes

# sync data
for i in {1..12}; do  # Retry up to 12 times
    tb datasource sync bq_pypi_data && echo "Success!" && exit 0
    echo "Attempt $i failed. Retrying in 10 seconds..."
    sleep 10
done

echo "Command failed after 12 attempts."
exit 1
