#!/usr/bin/env bash

export TB_VERSION_WARNING=0

run_test() {
    t=$1
    echo "** Running $t **"
    echo "** $(cat $t)"
    if res=$(bash $t $2 | diff -B ${t}.result -); then
        echo 'OK';
    else
        echo "failed, diff:";
        echo "$res";
        return 1
    fi
    echo ""
}
export -f run_test

fail=0
find ./tests -name "*.test" -print0 | xargs -0 -I {} -P 4 bash -c 'run_test "$@"' _ {} || fail=1

if [ $fail == 1 ]; then
  exit -1;
fi