#!/bin/bash
set -e

tb deploy
tb pipe copy run stock_prices_old_to_new --wait --yes
