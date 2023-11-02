#!/bin/bash
set -e

tb deploy --populate --fixtures --wait
tb pipe data pypi_downloads