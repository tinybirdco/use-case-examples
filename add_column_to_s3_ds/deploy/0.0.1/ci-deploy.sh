#!/bin/bash
set -e

# Dummy connection with te same name of the one in the main environment
tb connection create s3 --connection-name TB-S3  --key dummyKey --secret dummySecret --region eu-west-3 --no-validate

tb deploy --populate --fixtures --wait
