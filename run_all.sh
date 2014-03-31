#!/bin/bash
if [ ! -z $1 ]; then
    MODE=$1
else
    MODE="single"
fi

if [ ! -z $2 ]; then
    FS=$2
else
    FS="pmfs"
fi

if [ ! -z $3 ]; then
    JOPT=$3
else
    JOPT="journal"
fi

for L in a b c d e f
do
    WORKLOAD="workloads/workload{$L}"
    DB="test{$L}"
    ./run.sh "$WORKLOAD" "$DB" "$MODE" && mv histogram_*.txt timeseries_*.txt "/root/mongodb/experiments/${MODE}/${FS}/${JOPT}/$L" && cat err.txt
    echo "----------------------- TEST $L completed -----------------------"
    sleep 10s
done
