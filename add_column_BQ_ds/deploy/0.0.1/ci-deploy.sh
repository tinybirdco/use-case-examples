#!/bin/bash
set -e

tb deploy
tb pipe copy run bq_pypi_data_old_to_new --wait --yes