#!/bin/bash
set -e

tb deploy --yes
tb datasource sync bq_pypi_data
