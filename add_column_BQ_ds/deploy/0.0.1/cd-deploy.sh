#!/bin/bash
set -e

tb deploy
# alternatively you can do `tb datasource sync bq_pypi_new` to completely sync the Data Source again
# the copy in this case is faster although we don't have the country_code column yet
tb pipe copy run bq_pypi_data_old_to_new --wait --yes