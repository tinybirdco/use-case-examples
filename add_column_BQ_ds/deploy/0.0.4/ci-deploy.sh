#!/bin/bash
set -e

tb deploy --populate --fixtures --wait --yes
tb datasource sync bq_pypi_data
