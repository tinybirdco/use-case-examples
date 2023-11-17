#!/bin/bash
retry_duration=12 
retry_interval=1
max_retries=$((retry_duration / retry_interval))

# Parameters
BACKFILL_COLUMN="$1"
TARGET_DS="$2"
PIPE_NAME="$3"
NODE_NAME="$4"
OLDTARGET_DS="$5"
CONDITION="${6:-}"
BACKFILL_SOURCE_TABLE="${7:-$BACKFILL_COLUMN}"

BACKFILL_TIME=""
retry_count=0

while [[ $retry_count -lt $max_retries ]]; do
    output=$(tb --no-version-warning sql "select toDateTimeOrDefault(min($BACKFILL_COLUMN)) as t from $TARGET_DS" --format json)
    if [ -z "$output" ]; then
        echo "Output is empty"
        result=""
    else
        result=$(echo "$output" | python -c "import sys, json; print(json.load(sys.stdin)['data'][0]['t'])")
    fi

    if [[ -z $result || $result == "1970-01-01 00:00:00" ]]; then
        sleep $retry_interval
        retry_count=$((retry_count + 1))
    else
        BACKFILL_TIME=$result
        break
    fi
done

if [[ -z $BACKFILL_TIME ]]; then
    BACKFILL_TIME=$(date +"%Y-%m-%d %H:%M:%S")
fi

tb pipe populate $PIPE_NAME --node $NODE_NAME --sql-condition "$BACKFILL_SOURCE_TABLE < '$BACKFILL_TIME' $CONDITION" --wait

retry_count=0
while [[ $retry_count -lt $max_retries ]]; do
    diff=$(tb --no-version-warning sql "with (select count() from $TARGET_DS) as new, (select count() from $OLDTARGET_DS) as old select old - new as diff" --format json | python -c "import sys, json; print(json.load(sys.stdin)['data'][0]['diff'])")
    echo "Diff count: $diff"

    if [ $diff -eq 0 ]; then
        echo "Both counts are equal."
        exit 0
    else
        echo "Counts are not equal."
        sleep $retry_interval
        retry_count=$((retry_count + 1))
    fi
done

if [[ $retry_count -eq $max_retries ]]; then
    exit 1
fi
