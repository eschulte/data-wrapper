#!/bin/bash
#
# Run this script to test the data wrapper and generate an HTML file
# demonstrating its usage.
#
DATAFILE=mlb.txt
COLNAMES="name team position height weight age"

contains(){ echo "$1"|grep "$2" >/dev/null 2>/dev/null; }
fail_with(){ echo "FAIL: $@" >&2; exit 1; }
examplize(){ sed 's/^/    /';echo ""; }

test_run(){
    local cmd="$@";
    local OUT="$($cmd)"
    if [ ! $? -eq 0 ];then
        fail_with "'$cmd' failed with non-zero exit."
    else
        echo "$OUT"
    fi; }

test_exit(){
    local cmd="$@";
    local OUT="$(test_run $@)"
    echo "$ $cmd"|examplize
    echo "$OUT"  |examplize; }

test_contains(){
    local grep="$1"; shift;
    local cmd="$@";
    local OUT="$(test_run $@)"
    if ! $(contains "$OUT" "$grep");then
        fail_with "'$OUT' didn't match '$grep'."
    else
        echo "$ $cmd"|examplize
        echo "$OUT"  |examplize
    fi; }

test_not_contains(){
    local grep="$1"; shift;
    local cmd="$@";
    local OUT="$(test_run $@)"
    if $(contains "$OUT" "$grep");then
        fail_with "'$OUT' shouldn't have matched '$grep'."
    else
        echo "$ $cmd"|examplize
        echo "$OUT"  |examplize
    fi; }

should_exist(){
    local file="$1";
    if [ ! -f "$file" ];then
        fail_with "failed to create '$file'."
    fi; }

cat <<EOF

Example
-------

This example will use Major League Baseball player height and weight
data from
[wiki.stat.ucla.edu](http://wiki.stat.ucla.edu/socr/index.php/SOCR_Data_MLB_HeightsWeights)
available [here](./mlb.txt) as a text file.

EOF

## Test viewer creation
cat <<EOF

First \`data-wrapper\` is used to convert the raw text file into an
executable.

EOF

test_contains "mlb-viewer" ./data-wrapper $DATAFILE $COLNAMES
should_exist "mlb-viewer"

cat <<EOF

Because gzip compression is used, the executable is slightly smaller
than the original text file.

EOF

test_contains "mlb-viewer" ls -1s "mlb.txt mlb-viewer"

## Test help output
cat <<EOF

With the \`-h\` option we can view the functionality provided by the
new \`mlb-viewer\` executable.  For this example only long-form
options and column names will be used.

EOF

test_contains mlb-viewer ./mlb-viewer -h
for col in $COLNAMES;do
    test_contains $col ./mlb-viewer -h >/dev/null
done

## Test mean output
cat <<EOF

First lets look at the mean age by position.  If no result column is
specified, the last column is assumed which in this case is the age of
the payer.

EOF
test_contains "29.56" ./mlb-viewer --by position --mean

## Test specific result
cat <<EOF

However other result columns may be specified.

EOF
test_contains "204.329" ./mlb-viewer --by position --result weight --mean

## Test multiple categories
cat <<EOF

It is also possible to view results sorted by up to two column at
once; in this case by both team and position.

EOF
test_contains "201.667" ./mlb-viewer --by team,position --result weight --mean

## Test multiple results
cat <<EOF

Or to show multiple result columns at once; in this case both weight
and height.

EOF
test_contains "204.329/72.7237" ./mlb-viewer --by position --result weight,height --mean

## Test a graph of specific results
cat <<EOF

If your system has \`gnuplot\` installed, then these results may be graphed.

EOF
echo ./mlb-viewer --by position --result weight,height --mean --graph|examplize
./mlb-viewer -b p -r w,h -m -g -o weight-height-by-pos.svg >/dev/null
should_exist "weight-height-by-pos.svg"

cat <<EOF

![weight-height-by-pos.svg](./weight-height-by-pos.svg)

EOF

## Test correlation
# TODO: failing test
# test_contains "[0-9.]\+([0-9.]\+)" ./mlb-viewer --result weight,height --cor

## Test significance of weight differences between positions
cat <<EOF

If your system has \`R\` installed than statistical tests may be
performed on the data.  In the following example, we use a T-test to
calculate the significance of the difference in weight distribution
between every pair of positions.

EOF
test_contains "0(1)" ./mlb-viewer --by position --result weight --t-test

## Test normal calculation
cat <<EOF

T tests like the one above should only be used on normal
distributions.  We can test for normality of the distributions by
position with the following.

EOF
test_contains "0.9" ./mlb-viewer --by position --result weight --normal

cat <<EOF

Turns out most of these look pretty normal, aside from the infield.

EOF
