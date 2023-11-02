#!/bin/bash
set -e

tb deploy --populate --fixtures --wait
tb pipe data installations