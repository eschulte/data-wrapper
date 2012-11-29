#!/bin/bash
#
# Run this script to test the data wrapper and generate an HTML file
# demonstrating its usage.
#
contains(){ echo "$1"|grep "$2" >/dev/null 2>/dev/null; }
fail_with(){ echo "FAIL: $@" >&2; exit 1; }

DATAFILE=mlb.txt
COLNAMES="name team position height weight age"

test_contains(){
    local grep="$1"; shift;
    local cmd="$@";
    echo "$ $cmd"
    OUT="$($cmd)"
    if ! $(contains "$OUT" "$grep");then
        fail_with "'$OUT' didn't produce '$grep'."
    else
        echo "$OUT"
    fi; }

test_contains mlb-viewer ./data-wrapper $DATAFILE $COLNAMES

if [ ! -f mlb-viewer ];then
    fail_with "failed to create 'mlb-viewer'."
fi
